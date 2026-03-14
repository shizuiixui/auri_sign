import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auri_sign/config/api_constants.dart';

class BadgesViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  int totalBadges = 0;
  double totalPoints = 0.0;
  List<dynamic> earnedBadges = [];

  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<void> fetchUserProgress(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await _dio.get(
        '/progress/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data['data'] ?? response.data;

        totalBadges = (data['totalBadges'] as num?)?.toInt() ?? 0;
        totalPoints = (data['totalPoints'] as num?)?.toDouble() ?? 0.0;
        earnedBadges = data['badges'] ?? [];
      } else {
        errorMessage = 'Failed to load badges.';
      }
    } catch (e) {
      if (e is DioException) {
        errorMessage = e.response?.data is Map
            ? e.response?.data['message']
            : 'Server Error';
      } else {
        errorMessage = 'An unexpected error occurred.';
      }
      debugPrint("Badges Fetch Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
