import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/profile/viewmodels/streak_view_model.dart';
import 'package:auri_sign/features/profile/viewmodels/badges_view_model.dart';
import 'package:auri_sign/features/profile/presentation/screens/streak_page.dart';
import 'package:auri_sign/features/profile/presentation/screens/badges_page.dart';

class UserStatsRow extends StatelessWidget {
  // 🎯 Removed the hardcoded trophyCount parameter!
  const UserStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to both ViewModels for live data
    final streakVM = context.watch<StreakViewModel>();
    final badgesVM = context.watch<BadgesViewModel>();

    final currentStreak = streakVM.streakInfo?.currentStreak ?? 0;
    final totalBadges = badgesVM.totalBadges; // 🎯 Real data!

    return Row(
      children: [
        // 1. Badge
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BadgesPage()),
            );
          },
          child: Container(
            color: Colors.transparent,
            child: _buildStat(
              icon: Icons.military_tech,
              value: totalBadges.toString(),
              color: Colors.grey.shade700,
            ),
          ),
        ),

        const SizedBox(width: 15),

        // Streak
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StreakPage()),
            );
          },
          child: Container(
            color: Colors.transparent,
            child: _buildStat(
              icon: Icons.local_fire_department,
              value: currentStreak.toString(),
              color: const Color(0xFF1E74FD),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
