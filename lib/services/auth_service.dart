import 'package:dio/dio.dart';
import 'package:auri_sign/config/api_constants.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Response> sendOTP({required String email}) async {
    try {
      return await _dio.post('/api/otp/sendOTP', data: {'email': email});
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      return await _dio.post(
        '/api/otp/verifyOTP',
        data: {'email': email, 'otp': otp},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    int? learnerType,
    int? motivation,
    int? communicationContext,
    int? dailyTime,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      };

      if (learnerType != null &&
          motivation != null &&
          communicationContext != null) {
        requestData['profiling'] = {
          'learnerType': learnerType,
          'motivation': motivation,
          'communicationContext': communicationContext,
          'dailyTime': dailyTime,
        };
      }

      final response = await _dio.post('/api/auth/signup', data: requestData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
