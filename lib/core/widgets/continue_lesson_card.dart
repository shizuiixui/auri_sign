import 'package:flutter/material.dart';

class ContinueLessonCard extends StatelessWidget {
  final String title;
  final int completedLessons;
  final int totalLessons;
  final Color color;
  final String imagePath;

  const ContinueLessonCard({
    super.key,
    required this.title,
    required this.completedLessons,
    required this.totalLessons,
    required this.color,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    double ringProgress = totalLessons == 0
        ? 0.0
        : (completedLessons / totalLessons);

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Image Top, Title Bottom
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 8),
                // Title at the bottom
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Progress Ring
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: ringProgress,
                  strokeWidth: 6,
                  backgroundColor: Colors.white.withOpacity(0.4),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$completedLessons/$totalLessons",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Lessons",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
