import 'package:auri_sign/core/widgets/badges.dart';
import 'package:flutter/material.dart';

class BadgeDisplayHelper {
  static Widget getBadgeWidget(
    String badgeId, {
    String? badgeName,
    bool isGreyscale = false,
  }) {
    Widget badgeContent;
    final normalized = '${badgeId.toLowerCase()} ${badgeName?.toLowerCase() ?? ''}'.trim();

    // Check for Category Badges (Custom SVG Widgets)
    if (normalized.contains('alphabet')) {
      badgeContent = const AlphabetBadge();
    } else if (normalized.contains('number') || normalized.contains('numeric')) {
      badgeContent = const NumberBadge();
    } else if (normalized.contains('phrase')) {
      badgeContent = const PhraseBadge();
    }
    // Check for Streak Badges (PNG Images)
    else if (_isStreakBadge(normalized)) {
      String imagePath = _getStreakImagePath(normalized);
      badgeContent = Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.stars, size: 50, color: Colors.orange),
      );
    }
    // Generic fallback for any other badge
    else {
      badgeContent = const Icon(
        Icons.military_tech,
        size: 50,
        color: Color(0xFFFFB800),
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

  /// Check if the identifier/name is related to a streak badge
  static bool _isStreakBadge(String text) {
    return text.contains("streak") ||
        text.contains("warrior") ||
        text.contains("champion") ||
        text.contains("master") ||
        text.contains("legend") ||
        text.contains("centurion");
  }

  /// Private helper to get PNG paths for streak badges
  static String _getStreakImagePath(String text) {
    if (text.contains("streak_100") || text.contains("100-day") || text.contains("100 day") || text.contains("centurion")) {
      return 'assets/images/badges/Centurion.png';
    }
    if (text.contains("streak_50") || text.contains("50-day") || text.contains("50 day") || text.contains("legend")) {
      return 'assets/images/badges/50-DayLegend.png';
    }
    if (text.contains("streak_30") || text.contains("30-day") || text.contains("30 day") || text.contains("month")) {
      return 'assets/images/badges/MonthMaster.png';
    }
    if (text.contains("streak_14") || text.contains("14-day") || text.contains("14 day") || text.contains("two week") || text.contains("champion")) {
      return 'assets/images/badges/TwoWeekChampion.png';
    }
    if (text.contains("streak_7") || text.contains("7-day") || text.contains("7 day") || text.contains("week") || text.contains("warrior")) {
      return 'assets/images/badges/WeekWarrior.png';
    }
    if (text.contains("streak_3") || text.contains("3-day") || text.contains("3 day")) {
      return 'assets/images/badges/3-DayStreak.png';
    }

    // Default fallback streak image
    return 'assets/images/badges/3-DayStreak.png';
  }
}
