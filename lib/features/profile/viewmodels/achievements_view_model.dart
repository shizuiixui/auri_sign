import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auri_sign/config/api_constants.dart';
import 'package:auri_sign/features/lessons/data/repositories/lesson_repository.dart';
import 'package:auri_sign/services/certificate_service.dart';
import '../models/achievement_category.dart';

class AchievementsViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? downloadingCategoryId;
  String? previewingCategoryId;
  String? errorMessage;
  String? downloadErrorMessage;

  bool get isDownloading =>
      downloadingCategoryId != null || previewingCategoryId != null;

  bool isDownloadingCategory(String categoryId) =>
      downloadingCategoryId == categoryId;

  bool isPreviewingCategory(String categoryId) =>
      previewingCategoryId == categoryId;

  final LessonRepository _lessonRepo = LessonRepository(
    baseUrl: ApiConstants.baseUrl,
  );

  final CertificateService _certificateService = CertificateService();

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
      title: 'Phrases/Words',
      totalLessons: 9,
      completedLessons: 0,
    ),
  ];

  final Map<String, String> _completionDates = {};

  int get completedTracksCount => categories
      .where((c) => c.completedLessons >= c.totalLessons && c.totalLessons > 0)
      .length;

  int get totalTracksCount => categories.length;

  int get totalCompletedLessonsCount =>
      categories.fold(0, (sum, c) => sum + c.completedLessons);

  int get totalLessonsCount =>
      categories.fold(0, (sum, c) => sum + c.totalLessons);

  bool get isComprehensiveEligible =>
      categories.isNotEmpty && completedTracksCount >= totalTracksCount;

  String getCompletionDate(String categoryId) {
    return _completionDates[categoryId] ??
        DateFormat('MMMM d, yyyy').format(DateTime.now());
  }

  Future<void> _loadCompletionDates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayFormatted =
          DateFormat('MMMM d, yyyy').format(DateTime.now());

      for (var cat in categories) {
        if (cat.completedLessons >= cat.totalLessons && cat.totalLessons > 0) {
          final key = 'category_completed_date_${cat.id}';
          String? date = prefs.getString(key);
          if (date == null || date.isEmpty) {
            date = todayFormatted;
            await prefs.setString(key, date);
          }
          _completionDates[cat.id] = date;
        }
      }
    } catch (e) {
      debugPrint("Error loading completion dates: $e");
    }
  }

  String _toApiCategoryName(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'alphabets':
        return 'Alphabets';
      case 'numbers':
        return 'Numbers';
      case 'phrases':
      case 'phrases/words':
        return 'Phrases/Words';
      case 'comprehensive':
        return 'Comprehensive';
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

      await _loadCompletionDates();

      if (failedRequests == categories.length) {
        errorMessage = 'Unable to fetch achievements progress right now.';
      }
    } catch (e) {
      errorMessage = 'network error fetching achievements';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadCertificate(String categoryId, String userID) async {
    downloadingCategoryId = categoryId;
    downloadErrorMessage = null;
    notifyListeners();

    try {
      final apiCategoryName = _toApiCategoryName(categoryId);

      await _certificateService.downloadAndOpenCertificate(
        apiCategoryName,
        userID,
      );
    } catch (e) {
      downloadErrorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('Certificate download error: $e');
    } finally {
      downloadingCategoryId = null;
      notifyListeners();
    }
  }

  Future<void> previewCertificate(String categoryId, String userID) async {
    previewingCategoryId = categoryId;
    downloadErrorMessage = null;
    notifyListeners();

    try {
      final apiCategoryName = _toApiCategoryName(categoryId);

      await _certificateService.downloadAndOpenCertificate(
        apiCategoryName,
        userID,
      );
    } catch (e) {
      downloadErrorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('Certificate preview error: $e');
    } finally {
      previewingCategoryId = null;
      notifyListeners();
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
