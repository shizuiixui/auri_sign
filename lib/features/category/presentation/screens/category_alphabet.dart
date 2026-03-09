import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection_container.dart';
import '../../../lessons/data/repositories/lesson_repository.dart';
import '../../../lessons/presentation/viewmodels/lesson_view_model.dart';
import '../../../lessons/presentation/screens/lesson_execution_screen.dart';
import '../widgets/category_helper.dart';

class CategoryAlphabetsPage extends StatefulWidget {
  const CategoryAlphabetsPage({super.key});

  @override
  State<CategoryAlphabetsPage> createState() => _CategoryAlphabetsPageState();
}

class _CategoryAlphabetsPageState extends State<CategoryAlphabetsPage> {
  // Helper to navigate to the generic lesson screen
  void _navigateToLesson(String lessonId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => LessonViewModel(repository: sl<LessonRepository>()),
          child: LessonExecutionScreen(lessonId: lessonId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: const Color(0XFFF8F8F8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CategoryHeader(
                  title: "Learn each letter of Filipino Sign Language and practice your gestures with real-time recognition.",
                ),
                const SizedBox(height: 18),
                
                // Lesson 1
                Category(
                  title: "Lesson 1",
                  description: "Learn the first four letters of the alphabets",
                  status: LessonStatus.current,
                  onTap: () => _navigateToLesson("lesson-a-d"),
                ),
                const SizedBox(height: 16),

                // Lesson 2
                Category(
                  title: "Lesson 2",
                  description: "Learn the second four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("lesson-e-h"),
                ),
                const SizedBox(height: 16),

                /*
                // Lesson 3
                Category(
                  title: "Lesson 3",
                  description: "Learn the third four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("alphabet_3"),
                ),
                const SizedBox(height: 16),

                // Lesson 4
                Category(
                  title: "Lesson 4",
                  description: "Learn the fourth four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("alphabet_4"),
                ),
                const SizedBox(height: 16),

                // Lesson 5
                Category(
                  title: "Lesson 5",
                  description: "Learn the fifth four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("alphabet_5"),
                ),
                const SizedBox(height: 16),

                // Lesson 6
                Category(
                  title: "Lesson 6",
                  description: "Learn the sixth four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("alphabet_6"),
                ),
                const SizedBox(height: 16),

                // Lesson 7
                Category(
                  title: "Lesson 7",
                  description: "Learn the seventh four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("alphabet_7"),
                ),
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}