import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/lesson_model.dart';
import '../viewmodels/lesson_view_model.dart';
import '../widgets/lesson_widget_helpers.dart';

class LessonExecutionScreen extends StatefulWidget {
  final String lessonId;

  const LessonExecutionScreen({super.key, required this.lessonId});

  @override
  State<LessonExecutionScreen> createState() => _LessonExecutionScreenState();
}

class _LessonExecutionScreenState extends State<LessonExecutionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonViewModel>().startLesson(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LessonViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFE9B63B)),
        ),
      );
    }

    if (vm.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: Center(child: Text("Error: ${vm.errorMessage}")),
      );
    }

    if (vm.isLessonCompleted) {
      return LessonResultWidget(vm: vm);
    }

    final step = vm.currentStep;
    if (step == null)
      return const Scaffold(body: Center(child: Text("No data")));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: vm.progress,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFFE9B63B),
            minHeight: 8,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                "${step.stepNumber}/${vm.totalSteps}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildStepContent(step, vm),
        ),
      ),
    );
  }

  Widget _buildStepContent(LessonStep step, LessonViewModel vm) {
    switch (step.stepType) {
      case 'introduction':
        final videoUrl = step.metadata?['videoUrl']?.toString() ?? '';

        debugPrint("🔍 STEP ${step.stepNumber} DETECTED URL: '$videoUrl'");

        if (videoUrl.isNotEmpty) {
          return LearningStepWidget(
            step: step,
            onNext: vm.nextStep,
            onBack: vm.previousStep,
          );
        }
        return IntroductionStepWidget(step: step, onNext: vm.nextStep);
      case 'multipleChoice':
      case 'quiz':
        return QuizStepWidget(step: step, vm: vm);

      case 'gestureCheck':
        return GestureCheckStepWidget(step: step, onNext: vm.nextStep);

      default:
        return Center(child: Text("Unknown step type: ${step.stepType}"));
    }
  }
}
