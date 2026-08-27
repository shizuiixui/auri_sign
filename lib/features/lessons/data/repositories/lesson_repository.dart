import 'dart:convert';
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
      return DetailedCategoryProgress.fromJson(data);
    } else {
      throw Exception('Failed to load category progress');
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