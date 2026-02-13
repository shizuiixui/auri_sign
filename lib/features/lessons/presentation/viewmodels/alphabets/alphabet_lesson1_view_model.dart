import 'package:flutter/material.dart';

class AlphabetLesson1ViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  // Placeholder data
  final List<Map<String, String>> _lessonData = [
    {'letter': 'A', 'image': 'assets/images/homepage_FSL_img/letter_A_FSL.png'},
    {'letter': 'B', 'image': 'assets/images/homepage_FSL_img/letter_A_FSL.png'},
    {'letter': 'C', 'image': 'assets/images/homepage_FSL_img/letter_A_FSL.png'},
    {'letter': 'D', 'image': 'assets/images/homepage_FSL_img/letter_A_FSL.png'},
  ];

  // Getters
  int get currentIndex => _currentIndex;
  int get totalLessons => _lessonData.length;
  double get progress => (_currentIndex + 1) / _lessonData.length;
  String get currentLetter => _lessonData[_currentIndex]['letter']!;
  String get currentImage => _lessonData[_currentIndex]['image']!;
  bool get isFirst => _currentIndex == 0;
  bool get isLast => _currentIndex == _lessonData.length - 1;

  // Actions
  void nextLesson(BuildContext context) {
    if (!isLast) {
      _currentIndex++;
      notifyListeners();
    } else {
      Navigator.pop(context);
    }
  }

  void previousLesson() {
    if (!isFirst) {
      _currentIndex--;
      notifyListeners();
    }
  }
}
