import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          'http://192.168.100.10:5000/api', // Laptop's local IP for mobile device access
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
  }) async {
    try {
      final response = await _dio.post(
        '/auth/signup',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );
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
