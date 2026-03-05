import 'package:dio/dio.dart';

class ApiClient {
  static const String serverIp = String.fromEnvironment(
    'SERVER_IP',
    defaultValue: 'localhost',
  );
  static const String baseUrl = 'http://$serverIp:5000/api';

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
