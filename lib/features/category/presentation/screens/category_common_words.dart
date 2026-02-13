import 'package:flutter/material.dart';
import '/features/category/presentation/widgets/category_helper.dart';

class CategoryCommonWordsPage extends StatefulWidget {
  const CategoryCommonWordsPage({super.key});

  @override
  State<CategoryCommonWordsPage> createState() =>
      _CategoryCommonWordsPageState();
}

class _CategoryCommonWordsPageState extends State<CategoryCommonWordsPage> {
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
                      "Learn each common word of Filipino Sign Language and practice your gestures with real-time recognition.",
                ),
                const SizedBox(height: 18),
                // level 1
                Category(
                  title: "Lesson 1",
                  description: "Learn the easiest common words",
                  status: LessonStatus.current,
                  onTap: () {
                    Navigator.pushNamed(context, '/lesson_1');
                  },
                ),
                const SizedBox(height: 16),

                // level 2
                Category(
                  title: "Lesson 2",
                  description: "Learn the second set of common words",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/lesson_2');
                  },
                ),
                const SizedBox(height: 16),

                // level 3
                Category(
                  title: "Lesson 3",
                  description: "Learn the third set of common words",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/lesson_3');
                  },
                ),
                const SizedBox(height: 16),

                // level 4
                Category(
                  title: "Lesson 4",
                  description: "Learn the fourth set of common words",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/lesson_4');
                  },
                ),
                const SizedBox(height: 16),

                // level 5
                Category(
                  title: "Lesson 5",
                  description: "Learn the fifth set of common words",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/lesson_5');
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
