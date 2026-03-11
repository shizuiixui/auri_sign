import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/category_progress_model.dart';
import '../../data/repositories/lesson_repository.dart';

class CategoryViewModel extends ChangeNotifier {
  final LessonRepository repository;

  CategoryViewModel({required this.repository});

  bool isLoading = false;
  String? errorMessage;
  DetailedCategoryProgress? categoryData;
  List<CategorySummary> categorySummaries = [];

  Future<void> fetchCategoryProgress(String categoryName) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      categoryData = await repository.getCategoryProgress(categoryName, token);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllCategoriesSummary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      List<CategorySummary> tempSummaries = [];
      final categoriesToFetch = ["Alphabets", "Numbers", "Phrases/Words"];

      debugPrint("🔄 STARTING BYPASS: Fetching categories one by one...");

      for (String cat in categoriesToFetch) {
        try {
          final data = await repository.getCategoryProgress(cat, token);

          debugPrint(
            "✅ BYPASS SUCCESS [$cat]: ${data.completedLessons} / ${data.totalLessons}",
          );

          tempSummaries.add(
            CategorySummary(
              category: cat,
              totalLessons: data.totalLessons,
              completedLessons: data.completedLessons,
              isCompleted: data.isCompleted,
            ),
          );
        } catch (e) {
          debugPrint("⚠️ BYPASS SKIPPED [$cat]: $e");
        }
      }

      categorySummaries = tempSummaries;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error in Bypass: $e');
    }
  }
}
