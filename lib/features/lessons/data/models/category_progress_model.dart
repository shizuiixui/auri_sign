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

  DetailedCategoryProgress copyWith({
    bool? success,
    String? category,
    int? totalLessons,
    int? completedLessons,
    bool? isCompleted,
    List<LessonProgressItem>? lessonProgress,
  }) {
    return DetailedCategoryProgress(
      success: success ?? this.success,
      category: category ?? this.category,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      isCompleted: isCompleted ?? this.isCompleted,
      lessonProgress: lessonProgress ?? this.lessonProgress,
    );
  }
}

class LessonProgressItem {
  final String lessonId;
  final String title;
  final String description;
  final String status;
  final double score;
  final bool isUnlocked;

  LessonProgressItem({
    required this.lessonId,
    required this.title,
    required this.status,
    required this.score,
    required this.isUnlocked,
    required this.description,
  });

  factory LessonProgressItem.fromJson(Map<String, dynamic> json) {
    final lessonData = json['lesson'] is Map ? json['lesson'] : json;
    final progressData = json['userProgress'] ?? json['progress'];

    final String parsedLessonId = (lessonData['id'] ??
            lessonData['_id'] ??
            lessonData['lessonId'] ??
            json['lessonId'] ??
            json['id'] ??
            json['_id'] ??
            '')
        .toString();

    final String parsedTitle =
        (lessonData['title'] ?? json['title'] ?? '').toString();

    final String parsedDescription = (lessonData['description'] ??
            json['description'] ??
            'No description available.')
        .toString();

    final bool parsedIsUnlocked =
        (json['isUnlocked'] ?? json['unlocked'] ?? false) == true;

    String parsedStatus = parsedIsUnlocked ? 'active' : 'locked';
    double parsedScore = 0.0;

    if (progressData != null && progressData is Map) {
      final rawStatus = progressData['status']?.toString();
      final num? prevScore = progressData['previousScorePercentage'] as num?;
      final num? currScore = (progressData['scorePercentage'] ??
              progressData['score'] ??
              progressData['bestScore']) as num?;

      // Web App Parity (CategoryPage.jsx & CardLesson.jsx):
      // When a retake is in-progress, the server stores the previous completed score in previousScorePercentage
      if (rawStatus == 'in-progress' && prevScore != null) {
        parsedScore = prevScore.toDouble();
        parsedStatus = parsedScore >= 80 ? 'completed' : 'failed';
      } else if (rawStatus == 'completed') {
        final scoreVal = (currScore ?? prevScore)?.toDouble() ?? 0.0;
        parsedScore = scoreVal;
        parsedStatus = parsedScore >= 80 ? 'completed' : 'failed';
      } else if (rawStatus == 'in-progress') {
        parsedStatus = 'in_progress';
        parsedScore = (currScore ?? prevScore)?.toDouble() ?? 0.0;
      } else {
        parsedStatus = rawStatus ?? (parsedIsUnlocked ? 'active' : 'locked');
        parsedScore = (currScore ?? prevScore)?.toDouble() ?? 0.0;
      }
    } else {
      final num? directScore = (json['scorePercentage'] ?? json['score']) as num?;
      parsedScore = directScore?.toDouble() ?? 0.0;
      parsedStatus = (json['status'] ?? (parsedIsUnlocked ? 'active' : 'locked')).toString();
    }

    final bool effectiveUnlocked =
        parsedIsUnlocked || parsedScore >= 80 || parsedStatus == 'completed';

    return LessonProgressItem(
      lessonId: parsedLessonId,
      title: parsedTitle,
      description: parsedDescription,
      status: parsedStatus,
      score: parsedScore,
      isUnlocked: effectiveUnlocked,
    );
  }

  LessonProgressItem copyWith({
    String? lessonId,
    String? title,
    String? description,
    String? status,
    double? score,
    bool? isUnlocked,
  }) {
    return LessonProgressItem(
      lessonId: lessonId ?? this.lessonId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      score: score ?? this.score,
      isUnlocked: isUnlocked ?? this.isUnlocked,
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
