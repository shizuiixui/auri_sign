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
    upcomingBadges = _allBadges
        .map(
          (b) => {
            ...b,
            "imagePath": getBadgeImagePath(b['id']),
            "color": getBadgeColor(b['id']),
          },
        )
        .toList();
  }

  // Badges List
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
  ];

  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  String getBadgeImagePath(String? badgeId) {
    if (badgeId == null) return 'assets/images/badges/3-DayStreak.png';
    if (badgeId.contains("streak_3"))
      return 'assets/images/badges/3-DayStreak.png';
    if (badgeId.contains("streak_7"))
      return 'assets/images/badges/WeekWarrior.png';
    if (badgeId.contains("streak_14"))
      return 'assets/images/badges/TwoWeekChampion.png';
    if (badgeId.contains("streak_30"))
      return 'assets/images/badges/MonthMaster.png';
    if (badgeId.contains("streak_50"))
      return 'assets/images/badges/50-DayLegend.png';
    if (badgeId.contains("streak_100"))
      return 'assets/images/badges/Centurion.png';
    return 'assets/images/badges/3-DayStreak.png';
  }

  Color getBadgeColor(String? badgeId) {
    if (badgeId == null) return Colors.grey;
    if (badgeId.contains("streak_100")) return Colors.red;
    if (badgeId.contains("streak_50")) return const Color(0xFFFFB800);
    if (badgeId.contains("streak_30")) return Colors.blue;
    if (badgeId.contains("streak_14")) return Colors.lightBlue;
    if (badgeId.contains("streak_7")) return Colors.green;
    if (badgeId.contains("streak_3")) return Colors.grey.shade600;
    return Colors.grey;
  }

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

        final rawBadges = data['badges'] as List? ?? [];
        List<String> earnedIds = [];
        earnedBadges = [];

        for (var b in rawBadges) {
          if (b is Map) {
            String badgeId = b['badgeId'] ?? '';
            earnedIds.add(badgeId);
            earnedBadges.add({
              "badgeId": badgeId,
              "name": b['badgeName'] ?? 'Badge',
              "desc": b['description'] ?? '',
              "unlockedAt": b['unlockedAt'],
              "imagePath": getBadgeImagePath(badgeId),
              "color": getBadgeColor(badgeId),
            });
          }
        }

        upcomingBadges = _allBadges
            .where((b) {
              return !earnedIds.any((earnedId) => earnedId.contains(b['id']));
            })
            .map(
              (b) => {
                ...b,
                "imagePath": getBadgeImagePath(b['id']),
                "color": getBadgeColor(b['id']),
              },
            )
            .toList();
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('🚨 EXACT FAILED BADGES URL: ${e.requestOptions.uri}');
      }
      debugPrint("Badges Fetch Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
