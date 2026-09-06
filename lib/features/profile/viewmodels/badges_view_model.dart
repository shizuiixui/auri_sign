import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auri_sign/config/api_constants.dart';

class BadgesViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  int totalBadges = 0;
  double totalPoints = 0.0;

  List<Map<String, dynamic>> earnedBadges = [];
  List<Map<String, dynamic>> upcomingBadges = [];

  BadgesViewModel() {
    _updateUpcomingBadges([]);
  }

  // Fetch user progress from API
  final List<Map<String, dynamic>> _allBadges = [
    {
      "id": "streak_3",
      "days": 3,
      "name": "3-Day Streak",
      "desc": "Complete lessons for 3 consecutive days",
    },
    {
      "id": "streak_7",
      "days": 7,
      "name": "Week Warrior",
      "desc": "Complete lessons for 7 consecutive days",
    },
    {
      "id": "streak_14",
      "days": 14,
      "name": "Two Week Champion",
      "desc": "Complete lessons for 14 consecutive days",
    },
    {
      "id": "streak_30",
      "days": 30,
      "name": "Month Master",
      "desc": "Complete lessons for 30 consecutive days",
    },
    {
      "id": "streak_50",
      "days": 50,
      "name": "50-Day Legend",
      "desc": "Complete lessons for 50 consecutive days",
    },
    {
      "id": "streak_100",
      "days": 100,
      "name": "Centurion",
      "desc": "Complete lessons for 100 consecutive days",
    },
    {
      "id": "alphabet",
      "name": "Certified Alphabet Signer",
      "desc": "Complete all Alphabet lessons",
    },
    {
      "id": "number",
      "name": "Certified Numeric Signer",
      "desc": "Complete all Numeric lessons",
    },
    {
      "id": "phrase",
      "name": "Certified Phrase Communicator",
      "desc": "Complete all Phrase lessons",
    },
  ];

  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<void> fetchUserProgress(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await _dio.get(
        '/api/progress/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data['data'] ?? response.data;

        totalBadges = (data['totalBadges'] as num?)?.toInt() ?? 0;
        totalPoints = (data['totalPoints'] as num?)?.toDouble() ?? 0.0;

        final rawBadgesFromApi = data['badges'] as List? ?? [];
        List<String> earnedIdentifiers = [];
        earnedBadges = [];

        for (var b in rawBadgesFromApi) {
          if (b is Map) {
            String badgeId = (b['badgeId'] ?? b['id'] ?? b['_id'] ?? '').toString();
            String badgeName = (b['badgeName'] ?? b['name'] ?? 'Badge').toString();
            String desc = (b['description'] ?? b['desc'] ?? '').toString();

            if (badgeId.isNotEmpty) earnedIdentifiers.add(badgeId);
            if (badgeName.isNotEmpty) earnedIdentifiers.add(badgeName);

            // Store the data
            earnedBadges.add({
              "badgeId": badgeId,
              "name": badgeName,
              "desc": desc,
              "unlockedAt": b['unlockedAt'],
            });
          }
        }

        _updateUpcomingBadges(earnedIdentifiers);
      }
    } catch (e) {
      errorMessage = "Failed to load badges.";
      if (e is DioException) {
        debugPrint('🚨 EXACT FAILED BADGES URL: ${e.requestOptions.uri}');
        debugPrint('Response: ${e.response?.data}');
      }
      debugPrint("Badges Fetch Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Private helper to update upcoming badges based on earned identifiers (IDs and Names)
  void _updateUpcomingBadges(List<String> earnedIdentifiers) {
    final lowerEarned = earnedIdentifiers
        .map((e) => e.toLowerCase().trim())
        .where((e) => e.isNotEmpty)
        .toSet();

    upcomingBadges = _allBadges.where((hardcodedBadge) {
      final id = (hardcodedBadge['id'] as String? ?? '').toLowerCase().trim();
      final name = (hardcodedBadge['name'] as String? ?? '').toLowerCase().trim();

      final isEarned = lowerEarned.contains(id) ||
          lowerEarned.contains(name) ||
          lowerEarned.any((earned) =>
              (id.isNotEmpty && (earned.contains(id) || id.contains(earned))) ||
              (name.isNotEmpty && (earned.contains(name) || name.contains(earned))));

      return !isEarned;
    }).toList();
  }
}
