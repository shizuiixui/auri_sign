import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  bool get isCooldown => _cooldownSeconds > 0;
  int get cooldownSeconds => _cooldownSeconds;

  final AuthService _authService = AuthService();

  void _startCooldown(int seconds) {
    if (seconds <= 0) return;
    _cooldownTimer?.cancel();
    _cooldownSeconds = seconds;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds <= 1) {
        timer.cancel();
        _cooldownSeconds = 0;
        notifyListeners();
        return;
      }
      _cooldownSeconds -= 1;
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    if (isCooldown) {
      _errorMessage =
          'Too many login attempts. Please try again in a few minutes.';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    _token = null;
    notifyListeners();

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['token'] is String) {
          _token = data['token'] as String;
          // Save token to shared preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', _token!);
        } else {
          _errorMessage = 'Login succeeded but no token was returned.';
        }
      } else {
        final data = response.data;
        if (data is Map && data['message'] is String) {
          _errorMessage = data['message'] as String;
        } else {
          _errorMessage = 'Login failed.';
        }
      }
    } catch (e) {
      print('Login Error: $e');
      if (e is DioException) {
        print('DioException Status: ${e.response?.statusCode}');
        print('DioException Response: ${e.response?.data}');
        if (e.response != null) {
          if (e.response?.statusCode == 429) {
            final retryAfterHeader = e.response?.headers.value('retry-after');
            final retryAfterSeconds =
                int.tryParse(retryAfterHeader ?? '') ?? 15 * 60;
            _startCooldown(retryAfterSeconds);
          }
          final data = e.response?.data;
          if (data is Map && data['message'] is String) {
            _errorMessage = data['message'] as String;
          } else if (data is String) {
            _errorMessage = data;
          } else {
            _errorMessage = 'Login failed.';
          }
        } else {
          _errorMessage = 'Network error. Please check your connection.';
        }
      } else {
        print('Non-Dio Error: $e');
        _errorMessage = 'An unexpected error occurred: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }
}
