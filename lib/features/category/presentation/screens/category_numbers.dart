import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/features/category/presentation/widgets/category_helper.dart';
import '/services/lesson_service.dart';

class CategoryNumbersPage extends StatefulWidget {
  const CategoryNumbersPage({super.key});

  @override
  State<CategoryNumbersPage> createState() => _CategoryNumbersPageState();
}

class _CategoryNumbersPageState extends State<CategoryNumbersPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<LessonItem> _lessons = [];
  final LessonService _lessonService = LessonService();

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Sign in to load lessons.';
      });
      return;
    }

    try {
      final lessons = await _lessonService.fetchLessons(
        token: token,
        category: 'numbers',
      );
      if (!mounted) return;
      setState(() {
        _lessons = lessons;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Unable to load lessons.';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleLessonTap(int index) {
    const routes = ['/numbers_lesson1', '/numbers_lesson2', '/numbers_lesson3'];

    if (index < routes.length) {
      Navigator.pushNamed(context, routes[index]);
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Lesson coming soon.')));
  }

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
                if (_isLoading)
                  const Text(
                    'Loading lessons...',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                if (!_isLoading && _errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                if (!_isLoading && _errorMessage == null && _lessons.isEmpty)
                  const Text(
                    'No lessons available yet.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                if (!_isLoading && _errorMessage == null && _lessons.isNotEmpty)
                  ..._lessons.asMap().entries.map((entry) {
                    final index = entry.key;
                    final lesson = entry.value;
                    final firstIncompleteIndex = _lessons.indexWhere(
                      (item) => !item.completed,
                    );
                    final nextIndex = firstIncompleteIndex == -1
                        ? _lessons.length
                        : firstIncompleteIndex;

                    final status = lesson.completed
                        ? LessonStatus.completed
                        : (index == nextIndex
                              ? LessonStatus.current
                              : LessonStatus.locked);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Category(
                        title: lesson.title.isNotEmpty
                            ? lesson.title
                            : 'Lesson ${index + 1}',
                        description: lesson.description.isNotEmpty
                            ? lesson.description
                            : 'Lesson details coming soon.',
                        status: status,
                        onTap: () => _handleLessonTap(index),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
