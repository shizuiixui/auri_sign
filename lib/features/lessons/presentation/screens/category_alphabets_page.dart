import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection_container.dart';
import '../../../lessons/data/repositories/lesson_repository.dart';
import '../../../lessons/presentation/viewmodels/lesson_view_model.dart';
import '../../../lessons/presentation/viewmodels/category_view_model.dart';
import '../../../lessons/presentation/screens/lesson_execution_screen.dart';
import '../widgets/category_helper.dart';

class CategoryAlphabetsPage extends StatefulWidget {
  const CategoryAlphabetsPage({super.key});

  @override
  State<CategoryAlphabetsPage> createState() => _CategoryAlphabetsPageState();
}

class _CategoryAlphabetsPageState extends State<CategoryAlphabetsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryViewModel>().fetchCategoryProgress("Alphabets");
    });
  }

  void _navigateToLesson(String lessonId) async {
    String targetId = lessonId;
    if (targetId == "alphabet_1") {
      targetId = "lesson-a-d";
    }

    debugPrint("🚀 NAVIGATING TO LESSON ID: $targetId");

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => LessonViewModel(repository: sl<LessonRepository>()),
          child: LessonExecutionScreen(lessonId: targetId),
        ),
      ),
    );

    if (mounted) {
      context.read<CategoryViewModel>().fetchCategoryProgress("Alphabets");
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoryViewModel>();

    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
        title: const Text("Alphabets"),
        backgroundColor: const Color(0XFFF8F8F8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: vm.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFE9B63B)),
              )
            : vm.errorMessage != null
            ? _buildErrorState(vm.errorMessage!)
            : _buildLessonList(vm),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text("Error: $error", textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context
                  .read<CategoryViewModel>()
                  .fetchCategoryProgress("Alphabets"),
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonList(CategoryViewModel vm) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CategoryHeader(
              title:
                  "Learn each letter of Filipino Sign Language and practice your gestures.",
            ),
            const SizedBox(height: 18),
            if (vm.categoryData != null &&
                vm.categoryData!.lessonProgress.isNotEmpty)
              ...vm.categoryData!.lessonProgress.map((lesson) {
                LessonStatus uiStatus;
                if (lesson.status == 'completed') {
                  uiStatus = LessonStatus.completed;
                } else if (lesson.isUnlocked) {
                  uiStatus = LessonStatus.current;
                } else {
                  uiStatus = LessonStatus.locked;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Category(
                    title: lesson.title,
                    description: "Score: ${lesson.score}%",
                    status: uiStatus,
                    onTap: lesson.isUnlocked
                        ? () => _navigateToLesson(lesson.lessonId)
                        : () {},
                  ),
                );
              })
            else
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "No lessons found for this category.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
