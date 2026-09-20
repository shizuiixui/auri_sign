import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_progress_model.dart';
import 'package:flutter/foundation.dart';

class LessonRepository {
  final String baseUrl;

  LessonRepository({required this.baseUrl});

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<DetailedCategoryProgress> getCategoryProgress(String categoryName, [String? token]) async {
    final headers = await _getHeaders();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final encodedCategory = Uri.encodeComponent(categoryName);
    final url = Uri.parse('$baseUrl/api/lessons/user/categories/$encodedCategory/progress');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rawProgress = DetailedCategoryProgress.fromJson(data);
      return await _preserveBestProgress(rawProgress);
    } else {
      throw Exception('Failed to load category progress');
    }
  }

  Future<DetailedCategoryProgress> _preserveBestProgress(DetailedCategoryProgress progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('current_user_id') ?? '';
      final userPrefix = userId.isNotEmpty ? '${userId}_' : '';

      List<LessonProgressItem> mergedLessons = [];

      for (var lesson in progress.lessonProgress) {
        final id = lesson.lessonId.isNotEmpty ? lesson.lessonId : lesson.title;
        final scoreKey = 'lesson_best_score_$userPrefix$id';
        final statusKey = 'lesson_is_completed_$userPrefix$id';
        final legacyScoreKey = 'lesson_best_score_$id';
        final legacyStatusKey = 'lesson_is_completed_$id';

        // 1. Safely read cached score (handles both int and double safely)
        final rawCachedScore = prefs.get(scoreKey) ??
            (userPrefix.isNotEmpty ? prefs.get(legacyScoreKey) : null);
        double cachedBestScore = 0.0;
        if (rawCachedScore is num) {
          cachedBestScore = rawCachedScore.toDouble();
        }

        final cachedIsCompleted = (prefs.getBool(statusKey) ??
                (userPrefix.isNotEmpty
                    ? prefs.getBool(legacyStatusKey)
                    : null)) ??
            false;

        // Take the highest score between server API response and local cache
        final double bestScore = math.max(lesson.score, cachedBestScore);

        double finalScore = bestScore;
        String finalStatus = lesson.status;

        if (bestScore >= 80) {
          finalStatus = 'completed';
          await prefs.setDouble(scoreKey, bestScore);
          await prefs.setBool(statusKey, true);
        } else if (bestScore > 0) {
          finalStatus = (lesson.status == 'completed') ? 'completed' : 'in_progress';
          await prefs.setDouble(scoreKey, bestScore);
          await prefs.setBool(statusKey, false);
        } else if (cachedIsCompleted || lesson.status == 'completed') {
          finalStatus = 'completed';
        }

        mergedLessons.add(
          lesson.copyWith(
            status: finalStatus,
            score: finalScore,
            isUnlocked: lesson.isUnlocked || bestScore >= 80 || finalStatus == 'completed',
          ),
        );
      }

      // Sequential unlock cascade parity with web app:
      // First lesson is always unlocked; subsequent lessons are unlocked if previous lesson is passed (>= 80%)
      for (int i = 0; i < mergedLessons.length; i++) {
        if (i == 0) {
          mergedLessons[0] = mergedLessons[0].copyWith(isUnlocked: true);
        } else {
          final prevLesson = mergedLessons[i - 1];
          final bool prevPassed = prevLesson.score >= 80 || prevLesson.status == 'completed';
          if (prevPassed) {
            mergedLessons[i] = mergedLessons[i].copyWith(isUnlocked: true);
          }
        }
      }

      final completedCount = mergedLessons
          .where((l) => l.status == 'completed' && l.score >= 80)
          .length;
      final isAllCompleted =
          mergedLessons.isNotEmpty && completedCount >= mergedLessons.length;

      return progress.copyWith(
        completedLessons: math.max(progress.completedLessons, completedCount),
        isCompleted: progress.isCompleted || isAllCompleted,
        lessonProgress: mergedLessons,
      );
    } catch (e) {
      debugPrint("Error preserving best lesson progress: $e");
      return progress;
    }
  }

  Future<List<CategorySummary>> getAllCategoriesProgress() async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/api/lessons/user/categories/progress');

    debugPrint("🚀 FETCHING CAROUSEL SUMMARY: $url");

    try {
      final response = await http.get(url, headers: headers);
      
      debugPrint("📥 CAROUSEL STATUS CODE: ${response.statusCode}");
      debugPrint("📥 CAROUSEL DATA: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final categories = data['categories'] as List? ?? [];
        return categories.map((c) => CategorySummary.fromJson(c)).toList();
      }
    } catch (e) {
      debugPrint('❌ Error fetching carousel progress: $e');
    }
    return [];
  }
}