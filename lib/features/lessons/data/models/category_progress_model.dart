class DetailedCategoryProgress {
  final bool success;
  final String category;
  final int totalLessons;
  final int completedLessons;
  final bool isCompleted;
  final List<LessonProgressItem> lessonProgress;

  DetailedCategoryProgress({
    required this.success,
    required this.category,
    required this.totalLessons,
    required this.completedLessons,
    required this.isCompleted,
    required this.lessonProgress,
  });

  factory DetailedCategoryProgress.fromJson(Map<String, dynamic> json) {
    return DetailedCategoryProgress(
      success: json['success'] ?? false,
      category: json['category'] ?? '',
      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
      completedLessons: (json['completedLessons'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] ?? false,
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
  final int score;
  final bool isUnlocked;

  LessonProgressItem({
    required this.lessonId,
    required this.title,
    required this.status,
    required this.score,
    required this.isUnlocked,
  });

  factory LessonProgressItem.fromJson(Map<String, dynamic> json) {
    final lessonData = json['lesson'] ?? {};
    final progressData = json['userProgress'];

    return LessonProgressItem(
      lessonId: lessonData['id'] ?? '',
      title: lessonData['title'] ?? '',
      status: progressData != null ? progressData['status'] : 'locked',
      score: progressData != null
          ? (progressData['scorePercentage'] as num?)?.toInt() ?? 0
          : 0,
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }
}

class CategorySummary {
  final String category;
  final int totalLessons;
  final int completedLessons;
  final bool isCompleted;

  CategorySummary({
    required this.category,
    required this.totalLessons,
    required this.completedLessons,
    required this.isCompleted,
  });

  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    return CategorySummary(
      category: json['category'] ?? '',
      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
      completedLessons: (json['completedLessons'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
