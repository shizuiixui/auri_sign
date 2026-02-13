import 'package:flutter/material.dart';

enum LessonStatus { locked, current, completed }

class CategoryHeader extends StatelessWidget {
  final String title;

  const CategoryHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String title;
  final String description;
  final LessonStatus status;
  final VoidCallback onTap;

  const Category({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getBorderColor() {
      if (status == LessonStatus.current) return const Color(0xFFE9B63B);
      return Colors.transparent;
    }

    Color getButtonColor() {
      switch (status) {
        case LessonStatus.completed:
          return const Color(0xFF3B82F6);
        case LessonStatus.current:
          return const Color(0xFFE9B63B);
        case LessonStatus.locked:
          return const Color(0xFFE9B63B).withOpacity(0.4);
      }
    }

    IconData getIcon() {
      if (status == LessonStatus.completed) return Icons.check;
      return Icons.play_arrow_rounded;
    }

    return GestureDetector(
      onTap: status == LessonStatus.locked ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: getBorderColor(), width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: status == LessonStatus.locked
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: getButtonColor(),
                shape: BoxShape.circle,
              ),
              child: Icon(getIcon(), color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
