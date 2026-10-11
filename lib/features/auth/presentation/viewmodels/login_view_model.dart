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

  static const int _maxAttempts = 5;
  static const Duration _windowDuration = Duration(minutes: 15);
  static const String _rateLimitMessage =
      'Too many login attempts. Please try again later. (15 mins)';

  String _getAttemptKey(String email) {
    final normalized = email.trim().toLowerCase();
    return 'login_attempts_${normalized.isEmpty ? "unknown" : normalized}';
  }

  Future<bool> _isRateLimited(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    final windowMs = _windowDuration.inMilliseconds;
    final key = _getAttemptKey(email);

    final rawAttempts = prefs.getStringList(key) ?? [];
    final validAttempts = rawAttempts
        .map((e) => int.tryParse(e) ?? 0)
        .where((t) => now - t < windowMs)
        .toList();

    return validAttempts.length >= _maxAttempts;
  }

  Future<void> _recordAttempt(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    final windowMs = _windowDuration.inMilliseconds;
    final key = _getAttemptKey(email);

    final rawAttempts = prefs.getStringList(key) ?? [];
    final validAttempts = rawAttempts
        .map((e) => int.tryParse(e) ?? 0)
        .where((t) => now - t < windowMs)
        .toList();

    validAttempts.add(now);
    await prefs.setStringList(
      key,
      validAttempts.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _resetAttempts(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getAttemptKey(email);
    await prefs.remove(key);
  }

  Future<void> login({required String email, required String password}) async {
    if (await _isRateLimited(email)) {
      _errorMessage = _rateLimitMessage;
      _isLoading = false;
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
        await _resetAttempts(email);
        _token = response.data['token'];
        final userId = response.data['user']?['_id'] ?? response.data['user']?['id'];
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', _token!);
        if (userId != null) {
          await prefs.setString('current_user_id', userId.toString());
        }

        print("SUCCESS: Token safely stored on device disk!");
      } else {
        await _recordAttempt(email);
        _errorMessage = response.data['message'] ?? 'Login failed.';
      }
    } on DioException catch (e) {
      await _recordAttempt(email);
      print('Login Error: $e');
      if (e.response?.statusCode == 429) {
        _errorMessage = _rateLimitMessage;
      } else if (e.response?.data != null &&
          e.response?.data is Map &&
          e.response?.data['message'] != null) {
        _errorMessage = e.response!.data['message'].toString();
      } else {
        _errorMessage = 'Network error or invalid credentials.';
      }
    } catch (e) {
      await _recordAttempt(email);
      print('Login Error: $e');
      _errorMessage = 'Network error or invalid credentials.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkLoginStatus() async {
    print("STARTING APP: Searching device disk for saved token...");

    try {
      final prefs = await SharedPreferences.getInstance();

      final String? savedToken = prefs.getString('auth_token');

      if (savedToken != null && savedToken.isNotEmpty) {
        print(
          "FOUND TOKEN: User is still logged in. Bypassing Welcome Page.",
        );
        _token = savedToken;
        notifyListeners();
        return true;
      }

      print("NO TOKEN FOUND: User is logged out. Showing Welcome Page.");
      return false;
    } catch (e) {
      print("ERROR READING DISK: $e");
      return false;
    }
  }

  void clearSession() {
    _token = null;
    notifyListeners();
    print("SESSION CLEARED: LoginViewModel active memory has been wiped.");
  }
}
