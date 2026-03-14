class StreakInfo {
  final int currentStreak;
  final int longestStreak;
  final bool isActive;
  final DateTime? lastActivityDate;
  final DateTime? streakStartDate;
  final bool hasActivityToday;
  final int daysSinceLastActivity;
  final List<RecentActivity> recentActivity;
  final List<Milestone> milestones;

  StreakInfo({
    required this.currentStreak,
    required this.longestStreak,
    required this.isActive,
    this.lastActivityDate,
    this.streakStartDate,
    required this.hasActivityToday,
    required this.daysSinceLastActivity,
    required this.recentActivity,
    required this.milestones,
  });

  factory StreakInfo.fromJson(Map<String, dynamic> json) {
    return StreakInfo(
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] ?? false,
      lastActivityDate: json['lastActivityDate'] != null 
          ? DateTime.tryParse(json['lastActivityDate']) 
          : null,
      streakStartDate: json['streakStartDate'] != null 
          ? DateTime.tryParse(json['streakStartDate']) 
          : null,
      hasActivityToday: json['hasActivityToday'] ?? false,
      daysSinceLastActivity: (json['daysSinceLastActivity'] as num?)?.toInt() ?? 0,
      recentActivity: (json['recentActivity'] as List?)
              ?.map((item) => RecentActivity.fromJson(item))
              .toList() ?? [],
      milestones: (json['milestones'] as List?)
              ?.map((item) => Milestone.fromJson(item))
              .toList() ?? [],
    );
  }
}

class RecentActivity {
  final DateTime? date;
  final int lessonsCompleted;

  RecentActivity({required this.date, required this.lessonsCompleted});

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      lessonsCompleted: (json['lessonsCompleted'] as num?)?.toInt() ?? 0,
    );
  }
}

class Milestone {
  final int streakCount;
  final DateTime? achievedAt;

  Milestone({required this.streakCount, required this.achievedAt});

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      streakCount: (json['streakCount'] as num?)?.toInt() ?? 0,
      achievedAt: json['achievedAt'] != null ? DateTime.tryParse(json['achievedAt']) : null,
    );
  }
}