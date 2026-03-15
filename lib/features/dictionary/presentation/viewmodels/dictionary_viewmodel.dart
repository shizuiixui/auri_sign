import 'package:flutter/material.dart';
import '../../domain/models/dictionary_item.dart';
import '../../data/repositories/dictionary_repository.dart';

class DictionaryViewModel extends ChangeNotifier {
  final DictionaryRepository _repository;

  DictionaryViewModel(this._repository) {
    fetchData();
  }

  // State variables
  List<DictionaryItem> _allItems = [];
  DictionaryItem? signOfTheDay;

  bool isLoading = true;
  String errorMessage = "";

  String searchQuery = "";
  int selectedCategoryIndex = 0;
  bool showFilters = false;

  final List<String> categories = ["All", "Alphabets", "Numbers", "Phrases/Words"];

  // Filtering Logic
  List<DictionaryItem> get filteredList {
    List<DictionaryItem> filtered = _allItems;

    if (selectedCategoryIndex != 0) {
      String selectedCategory = categories[selectedCategoryIndex];
      filtered = filtered
          .where((item) => item.category == selectedCategory)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.term.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  // Data Fetching
  Future<void> fetchData() async {
    // 1. Check if token is actually there
    if (_repository.authToken.isEmpty) {
      print('DICTIONARY: No token found. Aborting fetch.');
      errorMessage = "Please log in again.";
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = "";
    notifyListeners();

    try {
      try {
        signOfTheDay = await _repository.fetchSignOfTheDay();
      } catch (e) {
        print('SIGN OF THE DAY ERROR: $e');
      }

      _allItems = await _repository.fetchAllItems();
    } catch (e) {
      print('==== API CONNECTION ERROR ====');
      print(e.toString());
      print('==============================');

      errorMessage = "Check your internet connection and try again.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // UI Actions
  void updateSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void toggleFilters() {
    showFilters = !showFilters;
    notifyListeners();
  }

  void selectCategory(int index) {
    selectedCategoryIndex = index;
    notifyListeners();
  }
}
