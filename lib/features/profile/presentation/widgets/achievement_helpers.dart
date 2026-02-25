import 'package:flutter/material.dart';

class AchievementProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String subtitle;
  final bool isExpanded;
  final VoidCallback onTap;

  const AchievementProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.subtitle,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isExpanded ? 0 : 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFFFB800), width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFFFB800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandedLessonsList extends StatelessWidget {
  final int totalLessons;
  final int completedLessons;

  const ExpandedLessonsList({
    super.key,
    required this.totalLessons,
    required this.completedLessons,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> lessons = [];
    for (int i = 1; i <= totalLessons; i++) {
      lessons.add(const VerticalStepLine());
      if (i <= completedLessons) {
        lessons.add(
          ActiveLessonStep(
            title: "Lesson $i Completed",
            subtitle: "0/4 completed", // Static Data
            progress: 1.0,
            number: i,
          ),
        );
      } else {
        lessons.add(InactiveLessonStep(title: "Lesson $i Locked", number: i));
      }
    }
    lessons.add(const SizedBox(height: 16));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: lessons),
    );
  }
}

class VerticalStepLine extends StatelessWidget {
  const VerticalStepLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 20, width: 1.5, color: Colors.grey.shade400);
  }
}

class ActiveLessonStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final int number;

  const ActiveLessonStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFFFB800), width: 1.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          LessonCoin(isActive: true, number: number),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFB800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InactiveLessonStep extends StatelessWidget {
  final String title;
  final int number;

  const InactiveLessonStep({
    super.key,
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          LessonCoin(isActive: false, number: number),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class LessonCoin extends StatelessWidget {
  final bool isActive;
  final int number;

  const LessonCoin({
    super.key,
    required this.isActive,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/your_coin_image.png',
            width: 30,
            height: 30,
            fit: BoxFit.contain,
            color: isActive ? null : Colors.grey,
            colorBlendMode: isActive ? null : BlendMode.saturation,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? const Color(0xFFDAA520)
                      : Colors.grey.shade300,
                ),
              );
            },
          ),
          Text(
            number.toString(),
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}