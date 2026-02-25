import 'package:flutter/material.dart';
import '../models/achievement_category.dart';

class AchievementsViewModel extends ChangeNotifier {
  final List<AchievementCategory> categories = [
    AchievementCategory(
      id: 'alphabets',
      title: 'Alphabets',
      totalLessons: 7,
      completedLessons: 0,
    ),
    AchievementCategory(
      id: 'numbers',
      title: 'Numbers',
      totalLessons: 2,
      completedLessons: 0,
    ),
    AchievementCategory(
      id: 'phrases',
      title: 'Phrases',
      totalLessons: 3,
      completedLessons: 0,
    ),
  ];

  final Map<String, bool> _expandedStates = {'alphabets': true};

  bool isExpanded(String id) => _expandedStates[id] ?? false;

  void toggleExpanded(String id) {
    _expandedStates[id] = !isExpanded(id);
    notifyListeners();
  }

  bool get isCertificateUnlocked {
    return categories.every((cat) => cat.completedLessons == cat.totalLessons);
  }
}

class CarouselViewModel extends ChangeNotifier {
  final List<CarouselItem> _items = [
    CarouselItem(
      title: "Common Words",
      imagePath: 'assets/images/homepage_FSL_img/common_words_FSL.png',
      progress: 0.0,
      colorHex: 0xFFE9B63B,
    ),
    CarouselItem(
      title: "Alphabets",
      imagePath: "assets/images/homepage_FSL_img/letter_A_FSL.png",
      progress: 0.0,
      colorHex: 0xFFE9B63B,
    ),
    CarouselItem(
      title: "Numbers",
      imagePath: "assets/images/homepage_FSL_img/number_1_FSL.png",
      progress: 0.0,
      colorHex: 0xFFE9B63B,
    ),
  ];

  List<CarouselItem> get items => _items;
}
