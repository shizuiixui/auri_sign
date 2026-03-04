class CategoryProgressResponse {
  final String category;
  final int totalLessons;
  final int completedLessons;
  final List<LessonProgressItem> lessonProgress;

  CategoryProgressResponse({
    required this.category,
    required this.totalLessons,
    required this.completedLessons,
    required this.lessonProgress,
  });

  factory CategoryProgressResponse.fromJson(Map<String, dynamic> json) {
    return CategoryProgressResponse(
      category: json['category'] ?? '',
      totalLessons: json['totalLessons'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
      lessonProgress:
          (json['lessonProgress'] as List?)
              ?.map((item) => LessonProgressItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class LessonProgressItem {
  final String lessonId;
  final String title;
  final String status;
  final bool isUnlocked;
  final int score;

  LessonProgressItem({
    required this.lessonId,
    required this.title,
    required this.status,
    required this.isUnlocked,
    required this.score,
  });

  factory LessonProgressItem.fromJson(Map<String, dynamic> json) {
    final lessonMap = json['lesson'] as Map<String, dynamic>?;
    final progressMap = json['userProgress'] as Map<String, dynamic>?;

    return LessonProgressItem(
      lessonId: (lessonMap?['id'] ?? lessonMap?['_id'] ?? 'ID_NOT_FOUND')
          .toString(),

      title: lessonMap?['title'] ?? 'Unknown Lesson',
      status: progressMap != null
          ? progressMap['status']
          : (json['isUnlocked'] == true ? 'current' : 'locked'),
      isUnlocked: json['isUnlocked'] ?? false,
      score: progressMap != null ? (progressMap['scorePercentage'] ?? 0) : 0,
    );
  }
}
