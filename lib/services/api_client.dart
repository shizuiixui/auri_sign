import 'package:dio/dio.dart';
import 'package:auri_sign/config/api_constants.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}