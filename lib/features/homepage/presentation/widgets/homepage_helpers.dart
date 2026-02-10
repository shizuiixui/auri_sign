import 'package:flutter/material.dart';

// Helper Widgets for HomePage
class HomeHeader extends StatelessWidget {
  final String firstName;
  final String? profilePicture;

  const HomeHeader({super.key, required this.firstName, this.profilePicture});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              backgroundImage: profilePicture != null
                  ? NetworkImage(profilePicture!)
                  : null,
              child: profilePicture == null
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hi",
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                ),
                Text(
                  "$firstName!",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Your Smart AI Sign Language\nLearning Companion",
          style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
        ),
      ],
    );
  }
}

// Continue Lesson Card Widget
class ContinueLessonCard extends StatelessWidget {
  final String title;
  final double progress;
  final Color color;
  final String imagePath;

  const ContinueLessonCard({
    super.key,
    required this.title,
    required this.progress,
    required this.color,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
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
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.white.withOpacity(0.4),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF3B82F6)),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "complete",
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

// Category Section Card Widget
class CategorySectionCard extends StatelessWidget {
  final String title;
  final Color color;
  final String imagePath;
  final String? bigDisplayChar;
  final IconData? bigDisplayIcon;

  const CategorySectionCard({
    super.key,
    required this.title,
    required this.color,
    required this.imagePath,
    this.bigDisplayChar,
    this.bigDisplayIcon,
  });

  @override
  Widget build(BuildContext context) {
    bool hasBigElement = bigDisplayChar != null || bigDisplayIcon != null;

    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (bigDisplayChar != null)
            Positioned(
              right: 20,
              bottom: 5,
              child: Text(
                bigDisplayChar!,
                style: TextStyle(
                  fontSize: 140,
                  height: 1,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Unna',
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),

          // Heart Icon
          if (bigDisplayIcon != null)
            Positioned(
              right: 3,
              bottom: 10,
              child: Icon(
                bigDisplayIcon,
                size: 100,
                color: Colors.white.withOpacity(0.3),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: hasBigElement ? 65.0 : 0.0),
                  child: Image.asset(
                    imagePath,
                    height: 60,
                    fit: BoxFit.contain,
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

// Daily Tracker Item Widget
class DailyTrackerItem extends StatelessWidget {
  final String day;
  final bool isCompleted;

  const DailyTrackerItem({
    super.key,
    required this.day,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),

          // Checkmark or Empty Space
          if (isCompleted)
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(Icons.check, size: 16, color: Colors.white),
            )
          else
            const SizedBox(height: 24),
        ],
      ),
    );
  }
}
