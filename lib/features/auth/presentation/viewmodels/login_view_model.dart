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
        final userId = response.data['user']?['_id'] ?? response.data['user']?['id'];
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', _token!);
        if (userId != null) {
          await prefs.setString('current_user_id', userId.toString());
        }

        print("SUCCESS: Token safely stored on device disk!");
      } else {
        _errorMessage = response.data['message'] ?? 'Login failed.';
      }
    } catch (e) {
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
