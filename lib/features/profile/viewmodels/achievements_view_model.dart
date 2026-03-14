import 'package:flutter/material.dart';
import 'package:auri_sign/config/api_constants.dart';
import 'package:auri_sign/features/lessons/data/repositories/lesson_repository.dart';
import '../models/achievement_category.dart';

class AchievementsViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  final LessonRepository _lessonRepo = LessonRepository(
    baseUrl: ApiConstants.baseUrl,
  );

  // defaultCategories
  List<AchievementCategory> categories = [
    AchievementCategory(
      id: 'alphabets',
      title: 'Alphabets',
      totalLessons: 9,
      completedLessons: 0,
    ),
    AchievementCategory(
      id: 'numbers',
      title: 'Numbers',
      totalLessons: 4,
      completedLessons: 0,
    ),
    AchievementCategory(
      id: 'phrases',
      title: 'Phrases',
      totalLessons: 9,
      completedLessons: 0,
    ),
  ];

  String _toApiCategoryName(String categoryId) {
    switch (categoryId) {
      case 'alphabets':
        return 'Alphabets';
      case 'numbers':
        return 'Numbers';
      case 'phrases':
        return 'Phrases/Words';
      default:
        return categoryId;
    }
  }

  Future<void> fetchAchievements() async {
    // preventDoubleFetchingRaceCondition
    if (isLoading) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners(); // showSpinner

    try {
      int failedRequests = 0;

      final futures = categories.map((cat) async {
        try {
          final apiCategoryName = _toApiCategoryName(cat.id);
          return await _lessonRepo.getCategoryProgress(apiCategoryName);
        } catch (e) {
          failedRequests++;
          debugPrint('Failed to fetch category progress for ${cat.id}: $e');
          return null;
        }
      }).toList();

      final results = await Future.wait(futures);

      // createBrandNewListToForceProviderToRebuildUi
      List<AchievementCategory> updatedCategories = [];

      for (int i = 0; i < categories.length; i++) {
        final data = results[i];
        if (data != null) {
          updatedCategories.add(
            AchievementCategory(
              id: categories[i].id,
              title: categories[i].title,
              totalLessons: data.totalLessons > 0
                  ? data.totalLessons
                  : categories[i].totalLessons,
              completedLessons: data.completedLessons,
            ),
          );
        } else {
          updatedCategories.add(categories[i]); // keepOldIfFailed
        }
      }

      // assignNewListAndNotify
      categories = updatedCategories;

      if (failedRequests == categories.length) {
        errorMessage = 'Unable to fetch achievements progress right now.';
      }
    } catch (e) {
      errorMessage = 'network error fetching achievements';
    } finally {
      isLoading = false;
      notifyListeners(); // 🎯 Force the UI to show the 5/9!
    }
  }
}

// carouselViewModelRemainsUnchanged
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
