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
        final scoreKey = 'lesson_best_score_$userPrefix${lesson.lessonId}';
        final statusKey = 'lesson_is_completed_$userPrefix${lesson.lessonId}';

        final cachedBestScore = prefs.getInt(scoreKey) ?? 0;
        final cachedIsCompleted = prefs.getBool(statusKey) ?? false;

        // A lesson is considered completed if the API reports it completed OR if it was previously completed
        final isCompleted = lesson.status == 'completed' || cachedIsCompleted;

        // If currently completed, mark it permanently
        if (lesson.status == 'completed') {
          await prefs.setBool(statusKey, true);
        }

        // Keep highest score achieved
        int bestScore = math.max(lesson.score, cachedBestScore);
        if (lesson.score > cachedBestScore) {
          await prefs.setInt(scoreKey, lesson.score);
        }

        // If the lesson was previously completed, never let an abandoned retake
        // overwrite it with 0% score and uncompleted status!
        final finalStatus = isCompleted ? 'completed' : lesson.status;
        final finalScore = isCompleted ? bestScore : lesson.score;

        mergedLessons.add(
          lesson.copyWith(
            status: finalStatus,
            score: finalScore,
          ),
        );
      }

      final completedCount = mergedLessons.where((l) => l.status == 'completed').length;
      final isAllCompleted = mergedLessons.isNotEmpty && completedCount >= mergedLessons.length;

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