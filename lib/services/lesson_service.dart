import 'package:dio/dio.dart';
import 'api_client.dart';

class LessonItem {
  final String id;
  final String category;
  final String title;
  final String description;
  final int durationMinutes;
  final bool completed;
  final DateTime? completedAt;

  LessonItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.completed,
    required this.completedAt,
  });

  factory LessonItem.fromMap(Map<String, dynamic> map) {
    final completedAtRaw = map['completedAt'];
    return LessonItem(
      id: map['_id']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Lesson',
      description: map['description']?.toString() ?? '',
      durationMinutes: map['durationMinutes'] is int
          ? map['durationMinutes'] as int
          : int.tryParse(map['durationMinutes']?.toString() ?? '') ?? 0,
      completed: map['completed'] == true,
      completedAt: completedAtRaw is String
          ? DateTime.tryParse(completedAtRaw)
          : null,
    );
  }
}

class LessonService {
  final Dio _dio = ApiClient().dio;

  Future<List<LessonItem>> fetchLessons({
    required String token,
    String? category,
  }) async {
    final path = category != null ? 'lessons/$category' : 'lessons';
    final response = await _dio.get(
      path,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data;
    if (data is Map && data['lessons'] is List) {
      final lessons = data['lessons'] as List;
      return lessons
          .whereType<Map>()
          .map(
            (lesson) => LessonItem.fromMap(Map<String, dynamic>.from(lesson)),
          )
          .toList();
    }

    return [];
  }
}
