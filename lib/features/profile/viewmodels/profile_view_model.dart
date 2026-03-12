import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/usecases/upload_profile_picture_usecase.dart';
import '../../../services/lesson_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final UploadProfilePictureUseCase uploadUseCase;
  final LessonService _lessonService;

  ProfileViewModel({required this.uploadUseCase, LessonService? lessonService})
    : _lessonService = lessonService ?? LessonService();

  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  int _streakCount = 0;
  int get streakCount => _streakCount;

  int _badgeCount = 0;
  int get badgeCount => _badgeCount;

  bool _isLoadingLearningStats = false;
  bool get isLoadingLearningStats => _isLoadingLearningStats;

  bool _hasLoadedLearningStats = false;
  bool get hasLoadedLearningStats => _hasLoadedLearningStats;

  Future<void> loadLearningStats() async {
    if (_isLoadingLearningStats) return;

    _isLoadingLearningStats = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        _streakCount = 0;
        _badgeCount = 0;
        _hasLoadedLearningStats = true;
        return;
      }

      final lessons = await _lessonService.fetchLessons(token: token);
      final completedLessons = lessons
          .where((lesson) => lesson.completed)
          .toList();

      final activeDays = <String>{};
      for (final lesson in completedLessons) {
        final completedAt = lesson.completedAt;
        if (completedAt == null) continue;

        final localDate = completedAt.toLocal();
        final dayKey =
            '${localDate.year}-${localDate.month.toString().padLeft(2, '0')}-${localDate.day.toString().padLeft(2, '0')}';
        activeDays.add(dayKey);
      }

      _streakCount = activeDays.length;
      _badgeCount = completedLessons.length;
      _hasLoadedLearningStats = true;
    } catch (_) {
      _streakCount = 0;
      _badgeCount = 0;
      _hasLoadedLearningStats = true;
    } finally {
      _isLoadingLearningStats = false;
      notifyListeners();
    }
  }

  Future<String?> pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );

      if (pickedFile == null) return null;

      _selectedImage = File(pickedFile.path);
      notifyListeners();

      _isUploading = true;
      notifyListeners();
      await uploadUseCase.call(_selectedImage!);

      _isUploading = false;
      notifyListeners();

      return "Profile picture updated successfully!";
    } catch (e) {
      _isUploading = false;
      notifyListeners();
      return "Failed to update image: $e";
    }
  }
}
