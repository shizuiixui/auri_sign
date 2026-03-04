import 'package:flutter/material.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/lesson_repository.dart';

class LessonViewModel extends ChangeNotifier {
  final LessonRepository repository;

  LessonViewModel({required this.repository});

  bool isLoading = false;
  String? errorMessage;

  // State from Server
  LessonStep? currentStep;
  int totalSteps = 0;
  bool isLessonCompleted = false;
  int finalScore = 0;
  String lessonId = '';

  // Quiz UI State
  String? selectedChoice;
  bool isAnswerSubmitted = false;
  bool? wasLastAnswerCorrect;

  // Pending state
  LessonStep? _nextStepPending;
  bool _shouldEndAfterContinue = false;

  double get progress =>
      totalSteps == 0 ? 0 : (currentStep?.stepNumber ?? 1) / totalSteps;

  Future<void> startLesson(String id) async {
    lessonId = id;
    isLoading = true;
    errorMessage = null;
    isLessonCompleted = false;
    notifyListeners();

    try {
      final response = await repository.startLesson(lessonId);
      currentStep = response.currentStep;
      totalSteps = response.totalSteps;
      _resetStepState();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void nextStep() {
    if (currentStep != null) {
      submitStepCompletion();
    }
  }

  void continueToNext() {
    if (_shouldEndAfterContinue) {
      isLessonCompleted = true;
    } else if (_nextStepPending != null) {
      currentStep = _nextStepPending;
      _nextStepPending = null;
    }
    _resetStepState();
    notifyListeners();
  }

  void previousStep() {
    debugPrint("Previous step requested (Not implemented in Server-Driven mode)");
  }

  Future<void> submitStepCompletion() async {
    if (currentStep == null) return;
    await _submitToApi("viewed");
  }

  void selectChoice(String choice) {
    if (isAnswerSubmitted) return;
    selectedChoice = choice;
    notifyListeners();
  }

  Future<void> submitQuizAnswer() async {
    if (selectedChoice == null) return;
    await _submitToApi(selectedChoice);
  }

  Future<void> submitGesture(double confidence) async {
    await _submitToApi("gesture", confidence: confidence);
  }

  Future<void> _submitToApi(dynamic answer, {double? confidence}) async {
    if (currentStep == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final response = await repository.submitAnswer(
        lessonId: lessonId,
        stepNumber: currentStep!.stepNumber,
        userAnswer: answer,
        confidence: confidence,
      );
      wasLastAnswerCorrect = response.isCorrect;
      isAnswerSubmitted = true;

      if (answer == "viewed") {
        if (response.lessonCompleted) {
          isLessonCompleted = true;
          finalScore = response.finalScore ?? 0;
        } else if (response.nextStep != null) {
          currentStep = response.nextStep;
          _resetStepState();
        }
      } else {
        if (response.lessonCompleted) {
          _shouldEndAfterContinue = true;
          finalScore = response.finalScore ?? 0;
        } else {
          _nextStepPending = response.nextStep;
        }
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _resetStepState() {
    selectedChoice = null;
    isAnswerSubmitted = false;
    wasLastAnswerCorrect = null;
    _nextStepPending = null;
    _shouldEndAfterContinue = false;
  }
}