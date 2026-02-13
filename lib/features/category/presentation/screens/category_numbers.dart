import 'package:flutter/material.dart';
import '/features/category/presentation/widgets/category_helper.dart';

class CategoryNumbersPage extends StatefulWidget {
  const CategoryNumbersPage({super.key});

  @override
  State<CategoryNumbersPage> createState() => _CategoryNumbersPageState();
}

class _CategoryNumbersPageState extends State<CategoryNumbersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
        title: const Text("Categories"),
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
                  title:
                      "Learn each number of Filipino Sign Language and practice your gestures with real-time recognition.",
                ),
                const SizedBox(height: 18),
                // level 1
                Category(
                  title: "Lesson 1",
                  description: "Learn the first four numbers",
                  status: LessonStatus.current,
                  onTap: () {
                    Navigator.pushNamed(context, '/numbers_lesson1');
                  },
                ),
                const SizedBox(height: 16),

                // level 2
                Category(
                  title: "Lesson 2",
                  description: "Learn the second four numbers",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/numbers_lesson2');
                  },
                ),
                const SizedBox(height: 16),

                // level 3
                Category(
                  title: "Lesson 3",
                  description: "Learn the third four numbers",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/numbers_lesson3');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
