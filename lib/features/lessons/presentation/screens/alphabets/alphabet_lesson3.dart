import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/alphabets/alphabet_lesson3_view_model.dart';
import '../../widgets/lesson_widget.dart';

class AlphabetLesson3Page extends StatelessWidget {
  const AlphabetLesson3Page({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AlphabetLesson3ViewModel>();

    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: viewModel.progress,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFFE9B63B),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${viewModel.currentIndex + 1}/${viewModel.totalLessons}",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Camera Area
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEBF5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    // Text
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: const [
                          Text(
                            "Analysing...", // placeholder, replace with actual status from ML model
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Confidence: 92%", // placeholder, replace with actual confidence from ML model
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Corners
                    const Center(child: CameraCornerOverlay()),
                  ],
                ),
              ),
            ),

            // Lesson Content Area
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE9B63B),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Alphabets Label
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Alphabets",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Image
                    Image.asset(
                      viewModel.currentImage,
                      height: 80,
                      errorBuilder: (c, o, s) =>
                          const Icon(Icons.broken_image, size: 60),
                    ),

                    const SizedBox(height: 8),

                    // Letter
                    Text(
                      viewModel.currentLetter,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LessonNavButton(
                          icon: Icons.arrow_back_ios_new,
                          onTap: viewModel.isFirst
                              ? null
                              : () => viewModel.previousLesson(),
                        ),
                        const SizedBox(width: 24),

                        LessonNavButton(
                          icon: Icons.arrow_forward_ios,
                          backgroundColor: const Color(0xFFE9B63B),
                          iconColor: Colors.white,
                          onTap: () => viewModel.nextLesson(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
