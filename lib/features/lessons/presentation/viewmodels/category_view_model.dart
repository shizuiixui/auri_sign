import 'package:flutter/material.dart';
import '../../data/models/category_progress_model.dart';
import '../../data/repositories/lesson_repository.dart';

class CategoryViewModel extends ChangeNotifier {
  final LessonRepository repository;

  CategoryViewModel({required this.repository});

  bool isLoading = true;
  String? errorMessage;
  CategoryProgressResponse? categoryData;

  Future<void> fetchCategoryProgress(String categoryName) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      categoryData = await repository.getCategoryProgress(categoryName);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}