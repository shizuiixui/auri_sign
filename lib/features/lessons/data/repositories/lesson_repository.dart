import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson_model.dart';
import '../models/category_progress_model.dart';

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

  Future<StartLessonResponse> startLesson(String lessonId) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/lessons/lessons/$lessonId/start');

    print("🚀 ATTEMPTING TO START LESSON");
    print("📍 URL: $url");
    print("🔑 LESSON ID SENT: '$lessonId'");

    final response = await http.post(url, headers: headers);

    print("📥 RESPONSE CODE: ${response.statusCode}");
    print("📥 RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return StartLessonResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to start lesson: ${response.body}');
    }
  }

  Future<SubmitAnswerResponse> submitAnswer({
    required String lessonId,
    required int stepNumber,
    required dynamic userAnswer,
    double? confidence,
  }) async {
    final headers = await _getHeaders();

    final Map<String, dynamic> body = {
      "stepNumber": stepNumber,
      "userAnswer": userAnswer,
    };

    if (confidence != null) {
      body["confidence"] = confidence;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/lessons/lessons/$lessonId/submit-answer'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return SubmitAnswerResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to submit answer: ${response.body}');
    }
  }

  Future<CategoryProgressResponse> getCategoryProgress(
    String categoryName,
  ) async {
    final headers = await _getHeaders();
    final encodedCategory = Uri.encodeComponent(categoryName);

    final response = await http.get(
      Uri.parse('$baseUrl/lessons/user/categories/$encodedCategory/progress'),
      headers: headers,
    );
    print("📡 RAW CATEGORY DATA: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CategoryProgressResponse.fromJson(data);
    } else {
      throw Exception('Failed to load category progress');
    }
  }
}
