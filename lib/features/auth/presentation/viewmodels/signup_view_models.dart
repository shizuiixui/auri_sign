import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> signup(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2)); 
    } catch (e) {
      _errorMessage = "Signup failed. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}