import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection_container.dart';
import '../../../lessons/data/repositories/lesson_repository.dart';
import '../../../lessons/presentation/viewmodels/lesson_view_model.dart';
import '../../../lessons/presentation/screens/lesson_execution_screen.dart';
import '../widgets/category_helper.dart';

class CategoryNumbersPage extends StatefulWidget {
  const CategoryNumbersPage({super.key});

  @override
  State<CategoryNumbersPage> createState() => _CategoryNumbersPageState();
}

class _CategoryNumbersPageState extends State<CategoryNumbersPage> {
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
                  title: "Learn each number of Filipino Sign Language and practice your gestures with real-time recognition.",
                ),
                const SizedBox(height: 18),

                // Lesson 1
                Category(
                  title: "Lesson 1",
                  description: "Learn the first four numbers",
                  status: LessonStatus.current,
                  onTap: () => _navigateToLesson("number_1"),
                ),
                const SizedBox(height: 16),

                // Lesson 2
                Category(
                  title: "Lesson 2",
                  description: "Learn the second four numbers",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("number_2"),
                ),
                const SizedBox(height: 16),

                // Lesson 3
                Category(
                  title: "Lesson 3",
                  description: "Learn the third four numbers",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("number_3"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}