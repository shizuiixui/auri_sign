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
  List<Map<String, dynamic>> allBadges = [];

  static final List<Map<String, dynamic>> _badgeDefinitions = [
    // Streak Milestones
    {
      "badgeId": "streak_3",
      "name": "3-Day Streak",
      "category": "Streak Milestone",
      "categoryType": "streak",
      "description": "Consistent effort pays off. Earned by learning 3 days in a row.",
      "criteria": "Complete lessons for 3 consecutive days.",
    },
    {
      "badgeId": "streak_7",
      "name": "Week Warrior",
      "category": "Streak Milestone",
      "categoryType": "streak",
      "description": "One full week of continuous dedication and signing practice!",
      "criteria": "Complete lessons for 7 consecutive days.",
    },
    {
      "badgeId": "streak_14",
      "name": "Two Week Champion",
      "category": "Streak Milestone",
      "categoryType": "streak",
      "description": "Two straight weeks of signing fluency and consistent habit.",
      "criteria": "Complete lessons for 14 consecutive days.",
    },
    {
      "badgeId": "streak_30",
      "name": "Month Master",
      "category": "Streak Milestone",
      "categoryType": "streak",
      "description": "A whole month of daily sign language practice. True dedication!",
      "criteria": "Complete lessons for 30 consecutive days.",
    },
    {
      "badgeId": "streak_50",
      "name": "50-Day Legend",
      "category": "Streak Milestone",
      "categoryType": "streak",
      "description": "Fifty consecutive days of signing excellence and dedication.",
      "criteria": "Complete lessons for 50 consecutive days.",
    },
    {
      "badgeId": "streak_100",
      "name": "Centurion",
      "category": "Streak Milestone",
      "categoryType": "streak",
      "description": "The triple-digit club! 100 consecutive days of mastery.",
      "criteria": "Complete lessons for 100 consecutive days.",
    },
    // Course Track Certifications
    {
      "badgeId": "certified_alphabet",
      "name": "Certified Alphabet Signer",
      "category": "Course Certification",
      "categoryType": "track",
      "description": "Mastered all A-Z finger spelling hand shapes and motions.",
      "criteria": "Complete all lessons in the Alphabet track.",
    },
    {
      "badgeId": "certified_numeric",
      "name": "Certified Numeric Signer",
      "category": "Course Certification",
      "categoryType": "track",
      "description": "Proficient in numbers and numeric hand sign expressions.",
      "criteria": "Complete all lessons in the Numbers track.",
    },
    {
      "badgeId": "certified_phrase",
      "name": "Certified Phrase Communicator",
      "category": "Course Certification",
      "categoryType": "track",
      "description": "Mastered essential everyday phrases, expressions, and sentences.",
      "criteria": "Complete all lessons in the Phrases track.",
    },
    // Platform Milestones
    {
      "badgeId": "first_lesson",
      "name": "First Steps",
      "category": "Platform Milestone",
      "categoryType": "milestone",
      "description": "Began your sign language journey by completing your first lesson.",
      "criteria": "Complete your very first lesson in any track.",
    },
    {
      "badgeId": "master",
      "name": "Sign Language Master",
      "category": "Platform Milestone",
      "categoryType": "milestone",
      "description": "The highest honor awarded to comprehensive sign language masters.",
      "criteria": "Achieve all track certifications and demonstrate comprehensive proficiency.",
    },
  ];

  BadgesViewModel() {
    _processBadges([]);
  }

  int get earnedCount => allBadges.where((b) => b['isEarned'] == true).length;
  int get lockedCount => allBadges.where((b) => b['isEarned'] != true).length;
  int get totalCount => allBadges.length;
  double get unlockedPercent => totalCount == 0 ? 0.0 : (earnedCount / totalCount);

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

        final rawBadgesFromApi = (data['badges'] as List? ?? [])
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        _processBadges(rawBadgesFromApi);
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

  void _processBadges(List<Map<String, dynamic>> rawBadgesFromApi) {
    allBadges = _badgeDefinitions.map((def) {
      final badgeCopy = Map<String, dynamic>.from(def);
      final match = _findMatchingApiBadge(def, rawBadgesFromApi);

      final isEarned = match != null;
      badgeCopy['isEarned'] = isEarned;
      badgeCopy['unlockedAt'] = match?['unlockedAt'];
      badgeCopy['desc'] = def['description']; // For backwards compatibility

      return badgeCopy;
    }).toList();

    earnedBadges = allBadges.where((b) => b['isEarned'] == true).toList();
    upcomingBadges = allBadges.where((b) => b['isEarned'] != true).toList();
  }

  Map<String, dynamic>? _findMatchingApiBadge(
    Map<String, dynamic> def,
    List<Map<String, dynamic>> rawBadgesFromApi,
  ) {
    final defId = (def['badgeId'] ?? '').toString().toLowerCase().trim();
    final defName = (def['name'] ?? '').toString().toLowerCase().trim();

    for (var b in rawBadgesFromApi) {
      final bId = (b['badgeId'] ?? b['id'] ?? b['_id'] ?? '').toString().toLowerCase().trim();
      final bName = (b['badgeName'] ?? b['name'] ?? '').toString().toLowerCase().trim();

      // Exact match on ID or Name
      if (bId.isNotEmpty && bId == defId) {
        return b;
      }
      if (bName.isNotEmpty && bName == defName) {
        return b;
      }

      // Track Aliases handling (not streak badges!)
      if (defId == 'certified_alphabet' && (bId.contains('alphabet') || bName.contains('alphabet'))) {
        return b;
      }
      if (defId == 'certified_numeric' && (bId.contains('number') || bId.contains('numeric') || bName.contains('numeric') || bName.contains('number'))) {
        return b;
      }
      if (defId == 'certified_phrase' && (bId.contains('phrase') || bName.contains('phrase'))) {
        return b;
      }
      if (defId == 'first_lesson' && (bId.contains('first') || bName.contains('first'))) {
        return b;
      }
      if (defId == 'master' && (bId == 'master' || bName == 'sign language master')) {
        return b;
      }
    }
    return null;
  }
}
