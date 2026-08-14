import 'package:dio/dio.dart';
import 'package:auri_sign/config/api_constants.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Response> sendOTP({required String email}) async {
    try {
      return await _dio.post('/otp/sendOTP', data: {'email': email});
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
        '/otp/verifyOTP',
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
      // Base user data
      final Map<String, dynamic> requestData = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      };

      // Profiling data
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

      // Send via Dio
      final response = await _dio.post('/auth/signup', data: requestData);
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
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
