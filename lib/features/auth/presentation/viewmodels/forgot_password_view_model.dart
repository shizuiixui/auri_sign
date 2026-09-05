import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:auri_sign/config/api_constants.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? _resetToken;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  final Dio _dio = Dio();

  // Request Password Reset
  Future<bool> requestReset(String email) async {
    _setLoading(true);
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/password-reset/request',
        data: {'email': email},
      );
      _successMessage = response.data['message'];
      return true;
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data['message'] ?? "Too many attempts. Try again later.";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify Reset Token
  Future<bool> verifyToken(String otp) async {
    _setLoading(true);
    try {
      await _dio.get(
        '${ApiConstants.baseUrl}/api/password-reset/verify-token',
        queryParameters: {'token': otp},
      );
      _resetToken = otp;
      return true;
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? "Invalid or expired OTP.";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reset Password
  Future<bool> resetPassword(String newPassword) async {
    if (_resetToken == null) return false;
    _setLoading(true);
    try {
      await _dio.post(
        '${ApiConstants.baseUrl}/api/password-reset/reset',
        data: {'token': _resetToken, 'newPassword': newPassword},
      );
      return true;
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data['message'] ?? "Failed to reset password.";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }
}
