import 'package:flutter/material.dart';
import '/features/category/presentation/widgets/category_helper.dart';

class CategoryAlphabetsPage extends StatefulWidget {
  const CategoryAlphabetsPage({super.key});

  @override
  State<CategoryAlphabetsPage> createState() => _CategoryAlphabetsPageState();
}

class _CategoryAlphabetsPageState extends State<CategoryAlphabetsPage> {
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
                      "Learn each letter of Filipino Sign Language and practice your gestures with real-time recognition.",
                ),
                const SizedBox(height: 18),
                // level 1
                Category(
                  title: "Lesson 1",
                  description: "Learn the first four letters of the alphabets",
                  status: LessonStatus.current,
                  onTap: () {
                    Navigator.pushNamed(context, '/alphabet_lesson1');
                  },
                ),
                const SizedBox(height: 16),

                // level 2
                Category(
                  title: "Lesson 2",
                  description: "Learn the second four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/alphabet_lesson2');
                  },
                ),
                const SizedBox(height: 16),

                // level 3
                Category(
                  title: "Lesson 3",
                  description: "Learn the third four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/alphabet_lesson3');
                  },
                ),
                const SizedBox(height: 16),

                // level 4
                Category(
                  title: "Lesson 4",
                  description: "Learn the fourth four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/alphabet_lesson4');
                  },
                ),
                const SizedBox(height: 16),

                // level 5
                Category(
                  title: "Lesson 5",
                  description: "Learn the fifth four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/alphabet_lesson5');
                  },
                ),
                const SizedBox(height: 16),

                // level 6
                Category(
                  title: "Lesson 6",
                  description: "Learn the sixth four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/alphabet_lesson6');
                  },
                ),
                const SizedBox(height: 16),

                // level 7
                Category(
                  title: "Lesson 7",
                  description:
                      "Learn the seventh four letters of the alphabets",
                  status: LessonStatus.locked,
                  onTap: () {
                    Navigator.pushNamed(context, '/alphabet_lesson7');
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
