import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './../data/models/streak_model.dart';
import 'package:auri_sign/config/api_constants.dart';

class StreakViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  StreakInfo? streakInfo;

  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<void> fetchStreakInfo() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await _dio.get(
        '/api/progress/streak/info',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['success'] == true) {
        streakInfo = StreakInfo.fromJson(response.data['data']);
      } else {
        errorMessage = response.data is Map
            ? response.data['message']
            : 'Failed to load streak data';
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('🚨 EXACT FAILED URL: ${e.requestOptions.uri}');
        if (e.response?.data is Map<String, dynamic>) {
          errorMessage =
              e.response?.data['message'] ?? 'Network error fetching streak.';
        } else {
          errorMessage = 'Server Error: ${e.response?.statusCode}';
          debugPrint("🚨 BACKEND FAILED! RAW RESPONSE: ${e.response?.data}");
        }
      } else {
        errorMessage = 'An unexpected error occurred.';
      }
      debugPrint("Streak Fetch Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
