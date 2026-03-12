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
        final data = response.data;
        if (data is Map<String, dynamic> && data['mfaRequired'] == true) {
          _errorMessage =
              'This account requires MFA verification. MFA login is not yet supported in the mobile app.';
          return;
        }

        _token = data is Map<String, dynamic> ? data['token'] as String? : null;

        if (_token == null || _token!.isEmpty) {
          _errorMessage = 'Login response did not include a token.';
          return;
        }

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', _token!);

        print("SUCCESS: Token safely stored on device disk!");
      } else {
        final data = response.data;
        _errorMessage = data is Map<String, dynamic>
            ? (data['message']?.toString() ?? 'Login failed.')
            : 'Login failed.';
      }
    } catch (e) {
      print('Login Error: $e');
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        if (responseData is Map<String, dynamic> &&
            responseData['message'] != null) {
          _errorMessage = responseData['message'].toString();
        } else if (statusCode == 401) {
          _errorMessage = 'Invalid credentials.';
        } else if (statusCode == 403) {
          _errorMessage = 'Please verify your email before logging in.';
        } else if (statusCode == 429) {
          _errorMessage = 'Too many login attempts. Please try again later.';
        } else {
          _errorMessage = 'Network error or server unavailable.';
        }
      } else {
        _errorMessage = 'Network error or invalid credentials.';
      }
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
        print("FOUND TOKEN: User is still logged in. Bypassing Welcome Page.");
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
