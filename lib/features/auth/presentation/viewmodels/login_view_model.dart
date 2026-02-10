import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;

  final AuthService _authService = AuthService();

  Future<void> login({required String email, required String password}) async {
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
        _token = response.data['token'];
        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
      } else {
        _errorMessage = response.data['message'] ?? 'Login failed.';
      }
    } catch (e) {
      print('Login Error: $e');
      if (e is DioException) {
        print('DioException Status: ${e.response?.statusCode}');
        print('DioException Response: ${e.response?.data}');
        if (e.response != null) {
          _errorMessage = e.response?.data['message'] ?? 'Login failed.';
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
}
