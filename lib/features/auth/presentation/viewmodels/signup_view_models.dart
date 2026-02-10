import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '/services/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  final AuthService _authService = AuthService();

  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await _authService.signup(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (response.statusCode == 201) {
        _successMessage = response.data['message'] ?? 'User registered successfully.';
        // Send OTP after successful signup (but don't block on failure)
        await sendOTP(email: email);
      } else {
        _errorMessage = response.data['message'] ?? 'Signup failed.';
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          _errorMessage = e.response?.data['message'] ?? 'Signup failed.';
        } else {
          _errorMessage = 'Network error. Please check your connection.';
        }
      } else {
        _errorMessage = 'An unexpected error occurred.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendOTP({required String email}) async {
    try {
      await _authService.sendOTP(email: email);
      return true;
    } catch (e) {
      // Don't overwrite the success message - OTP sending is secondary
      // Just log the error for debugging
      print('OTP sending failed: $e');
      if (e is DioException) {
        print('DioException Status: ${e.response?.statusCode}');
        print('DioException Response: ${e.response?.data}');
      }
      return false;
    }
  }

  Future<void> resendOTP({required String email}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.sendOTP(email: email);
      _successMessage = 'OTP resent successfully!';
      _errorMessage = null;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          _errorMessage = e.response?.data['message'] ?? 'Failed to resend OTP.';
        } else {
          _errorMessage = 'Network error. Please check your connection.';
        }
      } else {
        _errorMessage = 'Failed to resend OTP.';
      }
      print('Resend OTP error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}