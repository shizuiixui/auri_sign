class AchievementCategory {
  final String id;
  final String title;
  final int totalLessons;
  final int completedLessons;

  AchievementCategory({
    required this.id,
    required this.title,
    required this.totalLessons,
    required this.completedLessons,
  });

  double get progress =>
      totalLessons == 0 ? 0.0 : completedLessons / totalLessons;

  String get subtitle => "Lesson $completedLessons/$totalLessons completed";
}

class CarouselItem {
  final String title;
  final String imagePath;
  final double progress;
  final int colorHex; 

  CarouselItem({
    required this.title,
    required this.imagePath,
    required this.progress,
    required this.colorHex,
  });
}