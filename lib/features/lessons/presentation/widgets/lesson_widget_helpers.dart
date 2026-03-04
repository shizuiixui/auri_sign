import 'package:flutter/material.dart';
import '../../data/models/lesson_model.dart';
import '../viewmodels/lesson_view_model.dart';
import '../../../dictionary/presentation/widgets/dictionary_video_player_helpers.dart';

// Helper Widgets
BoxDecoration lessonBoxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: const Color(0xFFE9B63B), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

// Buttons
class LessonPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const LessonPrimaryButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE9B63B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class LessonSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const LessonSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// Introduction Widget
class IntroductionStepWidget extends StatelessWidget {
  final LessonStep step;
  final VoidCallback onNext;

  const IntroductionStepWidget({
    super.key,
    required this.step,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        const Spacer(),

        Container(
          height: screenHeight * 0.35,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          decoration: lessonBoxDecoration(),

          child: SingleChildScrollView(
            child: Text(
              step.content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                height: 1.5,
              ),
            ),
          ),
        ),

        const Spacer(),

        LessonPrimaryButton(text: "Next", onPressed: onNext),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Learning Step Widget
class LearningStepWidget extends StatelessWidget {
  final LessonStep step;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const LearningStepWidget({
    super.key,
    required this.step,
    required this.onNext,
    required this.onBack,
  });

  Widget _buildStyledText(String content) {
    final regex = RegExp(
      r'(.*letter\s+)([a-zA-Z0-9])(.*)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(content);
    if (match != null) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            color: Colors.black,
            height: 1.5,
          ),
          children: [
            TextSpan(text: match.group(1)),
            TextSpan(
              text: match.group(2),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            TextSpan(text: match.group(3)),
          ],
        ),
      );
    }
    return Text(
      content,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontFamily: 'Poppins', height: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoUrl = step.metadata?['videoUrl'] ?? '';
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: lessonBoxDecoration(),
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: videoUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: DictionaryVideoPlayer(videoUrl: videoUrl),
                        )
                      : const Center(
                          child: Icon(
                            Icons.videocam_off,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 70),
              _buildStyledText(step.content),
              const SizedBox(height: 8),
            ],
          ),
        ),

        const Spacer(),

        LessonPrimaryButton(text: "Next", onPressed: onNext),
        const SizedBox(height: 12),
        LessonSecondaryButton(text: "Back", onPressed: onBack),

        const SizedBox(height: 20),
      ],
    );
  }
}

// Quiz Widget
class QuizStepWidget extends StatelessWidget {
  final LessonStep step;
  final LessonViewModel vm;
  const QuizStepWidget({super.key, required this.step, required this.vm});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> choicesData = step.metadata?['choices'] ?? [];
    final videoUrl = step.metadata?['videoUrl'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Assessment",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Let’s see what you remember from the lesson.",
          style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 16),
        Container(
          height: 176,
          width: double.infinity,
          decoration: lessonBoxDecoration(),
          child: videoUrl.isNotEmpty
              ? DictionaryVideoPlayer(
                  key: ValueKey(videoUrl), 
                  videoUrl: videoUrl,
                )
              : Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
        ),
        const SizedBox(height: 30),
        Center(
          child: Text(
            step.content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
          ),
        ),
        const SizedBox(height: 20),

        ...choicesData.map((choice) {
          final String choiceText = choice['text'] ?? '';
          final String choiceId = choice['id'] ?? choiceText;
          final bool isCorrect = choice['isCorrect'] ?? false;
          final isSelected = vm.selectedChoice == choiceId;

          Color borderColor = Colors.grey.shade300;
          Color bgColor = Colors.white;
          Color textColor = Colors.black;

          if (vm.isAnswerSubmitted) {
            // 🎯 POST-SUBMISSION LOGIC
            if (isCorrect) {
              borderColor = Colors.green;
              bgColor = Colors.green.shade50;
              textColor = Colors.green.shade900;
            } else if (isSelected) {
              borderColor = Colors.red;
              bgColor = Colors.red.shade50;
              textColor = Colors.red.shade900;
            }
          } else if (isSelected) {
            borderColor = const Color(0xFFE9B63B);
            bgColor = const Color(0xFFFFF4D9);
          }

          return GestureDetector(
            onTap: vm.isAnswerSubmitted
                ? null
                : () => vm.selectChoice(choiceId),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 14),
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Center(
                child: Text(
                  choiceText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
          );
        }).toList(),

        const Spacer(),

        if (vm.isAnswerSubmitted)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                vm.wasLastAnswerCorrect == true
                    ? "Correct! Great Job"
                    : "Not Quite! The correct answer is highlighted",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: vm.wasLastAnswerCorrect == true
                      ? const Color(0xFF008000)
                      : const Color(0xFFFF0000),
                ),
              ),
            ),
          ),

        if (!vm.isAnswerSubmitted)
          LessonPrimaryButton(
            text: "Submit Answer",
            onPressed: vm.selectedChoice != null && !vm.isLoading
                ? () => vm.submitQuizAnswer()
                : null,
          )
        else
          LessonPrimaryButton(
            text: "Continue",
            onPressed: () => vm.continueToNext(),
          ),
      ],
    );
  }
}

// GESTURE CHECK WIDGET ---

class GestureCheckStepWidget extends StatelessWidget {
  final LessonStep step;
  final VoidCallback onNext;
  const GestureCheckStepWidget({
    super.key,
    required this.step,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Gesture Check",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),

        Text(step.content),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: lessonBoxDecoration(),
            child: Stack(
              children: [
                const Center(child: Text("Camera Feed Placeholder")),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Confidence: 0%",
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: 0.1,
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Hold steady 0s/5s",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        LessonPrimaryButton(text: "Start Check", onPressed: onNext),
      ],
    );
  }
}

// RESULT WIDGET
class LessonResultWidget extends StatelessWidget {
  final LessonViewModel vm;
  const LessonResultWidget({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Lesson Complete!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 60,
                ),
                decoration: lessonBoxDecoration(),
                child: Column(
                  children: [
                    Text(
                      "${vm.finalScore}%", // Uses API Final Score
                      style: const TextStyle(
                        fontSize: 48,
                        color: Color(0xFFE9B63B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Final Score",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              LessonPrimaryButton(
                text: "Back to Lessons",
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
