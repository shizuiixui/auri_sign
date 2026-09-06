import 'package:auri_sign/core/widgets/badges.dart';
import 'package:flutter/material.dart';

class BadgeDisplayHelper {
  static Widget getBadgeWidget(String badgeId, {bool isGreyscale = false}) {
    Widget badgeContent;

    // Check for Category Badges (Custom SVG Widgets)
    if (badgeId == 'alphabet') {
      badgeContent = const AlphabetBadge();
    } else if (badgeId == 'number') {
      badgeContent = const NumberBadge();
    } else if (badgeId == 'phrase') {
      badgeContent = const PhraseBadge();
    }
    // Check for Streak Badges (PNG Images)
    else {
      String imagePath = _getStreakImagePath(badgeId);
      badgeContent = Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.stars, size: 50, color: Colors.orange),
      );
    }

    if (isGreyscale) {
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
        child: badgeContent,
      );
    }

    return badgeContent;
  }

  /// Private helper to get PNG paths for streak badges
  static String _getStreakImagePath(String badgeId) {
    if (badgeId.contains("streak_3"))
      return 'assets/images/badges/3-DayStreak.png';
    if (badgeId.contains("streak_7"))
      return 'assets/images/badges/WeekWarrior.png';
    if (badgeId.contains("streak_14"))
      return 'assets/images/badges/TwoWeekChampion.png';
    if (badgeId.contains("streak_30"))
      return 'assets/images/badges/MonthMaster.png';
    if (badgeId.contains("streak_50"))
      return 'assets/images/badges/50-DayLegend.png';
    if (badgeId.contains("streak_100"))
      return 'assets/images/badges/Centurion.png';

    // Default fallback image
    return 'assets/images/badges/3-DayStreak.png';
  }
}
