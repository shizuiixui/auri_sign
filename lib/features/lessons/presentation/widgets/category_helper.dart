import 'package:flutter/material.dart';

// Status Enum
enum LessonStatus { locked, current, completed }

// Header Widget
class CategoryHeader extends StatelessWidget {
  final String title;
  final Color? backgroundColor;

  const CategoryHeader({
    super.key,
    required this.title,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? const Color(0xFFE9B63B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Overview",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

// Category/Lesson Item Widget
class Category extends StatelessWidget {
  final String title;
  final String description;
  final LessonStatus status;
  final VoidCallback onTap;
  final Color? themeColor;

  const Category({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.onTap,
    this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    // Determine styles based on status
    final bool isLocked = status == LessonStatus.locked;
    final bool isCompleted = status == LessonStatus.completed;
    final bool isCurrent = status == LessonStatus.current;
    final Color activeColor = themeColor ?? const Color(0xFFE9B63B);

    Color borderColor = Colors.transparent;
    Color iconColor = Colors.grey;
    IconData statusIcon = Icons.lock;
    double opacity = 0.6;

    if (isCurrent) {
      borderColor = activeColor;
      iconColor = activeColor;
      statusIcon = Icons.play_arrow_rounded;
      opacity = 1.0;
    } else if (isCompleted) {
      borderColor = Colors.green;
      iconColor = Colors.green;
      statusIcon = Icons.check_circle_rounded;
      opacity = 1.0;
    } else {
      borderColor = activeColor.withValues(alpha: 0.35);
    }

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isCurrent || isCompleted ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.grey[200]
                      : iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  statusIcon,
                  color: isLocked ? Colors.grey : iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: isLocked ? Colors.grey : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isLocked ? Colors.grey : Colors.black54,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),

              if (!isLocked)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
