import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection_container.dart';
import '../../../lessons/data/repositories/lesson_repository.dart';
import '../../../lessons/presentation/viewmodels/lesson_view_model.dart';
import '../../../lessons/presentation/screens/lesson_execution_screen.dart';
import '../widgets/category_helper.dart';

class CategoryCommonWordsPage extends StatefulWidget {
  const CategoryCommonWordsPage({super.key});

  @override
  State<CategoryCommonWordsPage> createState() => _CategoryCommonWordsPageState();
}

class _CategoryCommonWordsPageState extends State<CategoryCommonWordsPage> {
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
                  title: "Learn each common word of Filipino Sign Language and practice your gestures with real-time recognition.",
                ),
                const SizedBox(height: 18),

                // Lesson 1
                Category(
                  title: "Lesson 1",
                  description: "Learn the easiest common words",
                  status: LessonStatus.current,
                  onTap: () => _navigateToLesson("common_word_1"),
                ),
                const SizedBox(height: 16),

                // Lesson 2
                Category(
                  title: "Lesson 2",
                  description: "Learn the second set of common words",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("common_word_2"),
                ),
                const SizedBox(height: 16),

                // Lesson 3
                Category(
                  title: "Lesson 3",
                  description: "Learn the third set of common words",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("common_word_3"),
                ),
                const SizedBox(height: 16),

                // Lesson 4
                Category(
                  title: "Lesson 4",
                  description: "Learn the fourth set of common words",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("common_word_4"),
                ),
                const SizedBox(height: 16),

                // Lesson 5
                Category(
                  title: "Lesson 5",
                  description: "Learn the fifth set of common words",
                  status: LessonStatus.locked,
                  onTap: () => _navigateToLesson("common_word_5"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}