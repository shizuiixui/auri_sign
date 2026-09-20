import 'package:flutter/material.dart';

// Status Enum
enum LessonStatus { locked, current, retake, completed }

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
  final double? score;

  const Category({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.onTap,
    this.themeColor,
    this.score,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLocked = status == LessonStatus.locked;
    final bool isCompleted = status == LessonStatus.completed;
    final bool isRetake = status == LessonStatus.retake;
    final bool isCurrent = status == LessonStatus.current;
    final Color activeColor = themeColor ?? const Color(0xFFE9B63B);

    final bool hasScore = score != null && score! > 0;

    // Web-parity soft red colors for failed/retake (< 80%) lessons
    const Color failedContainerBg = Color(0xFFFFF6F5);
    const Color failedContainerBorder = Color(0xFFF3B4AE);
    const Color failedBadgeBg = Color(0xFFD45D55);
    const Color failedText = Color(0xFFB23B35);
    const Color failedIconBg = Color(0xFFFCE8E6);
    const Color failedIconText = Color(0xFFC85A54);

    // Border color and width
    Color borderColor;
    double borderWidth;
    if (isRetake) {
      borderColor = failedContainerBorder;
      borderWidth = 1.2;
    } else if (isCompleted || isCurrent) {
      borderColor = activeColor.withValues(alpha: 0.7);
      borderWidth = 1.2;
    } else {
      borderColor = activeColor.withValues(alpha: 0.25);
      borderWidth = 1.0;
    }

    // Card background color
    Color cardBgColor;
    if (isRetake) {
      cardBgColor = failedContainerBg;
    } else if (isCompleted) {
      cardBgColor = activeColor.withValues(alpha: 0.08);
    } else {
      cardBgColor = Colors.white;
    }

    // Score badge color
    Color badgeColor;
    if (isRetake) {
      badgeColor = failedBadgeBg;
    } else {
      badgeColor = activeColor;
    }

    // Action button styling
    Widget actionButton;
    if (isCompleted) {
      actionButton = Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: activeColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 24,
        ),
      );
    } else if (isRetake) {
      actionButton = Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: failedIconBg,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.refresh_rounded,
          color: failedIconText,
          size: 22,
        ),
      );
    } else if (isCurrent) {
      actionButton = Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: activeColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: activeColor,
          size: 26,
        ),
      );
    } else {
      actionButton = Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.lock,
          color: Colors.grey.shade400,
          size: 20,
        ),
      );
    }

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Opacity(
        opacity: isLocked ? 0.6 : 1.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Score Badge
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: isLocked ? Colors.grey : Colors.black87,
                          ),
                        ),
                        if (hasScore)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${score!.toStringAsFixed(2)}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: isLocked
                            ? Colors.grey
                            : Colors.black87.withValues(alpha: 0.7),
                        height: 1.4,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    if (isCompleted) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            size: 15,
                            color: activeColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Tap to retake",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: activeColor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ] else if (isRetake) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Retake to reach 80% and unlock the next lesson",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: failedText,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 14),
              actionButton,
            ],
          ),
        ),
      ),
    );
  }
}
