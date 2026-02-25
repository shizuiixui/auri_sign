import 'package:flutter/material.dart';

class UserStatsRow extends StatelessWidget {
  final int trophyCount;
  final int streakCount;

  const UserStatsRow({
    super.key,
    required this.trophyCount,
    required this.streakCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStat(Icons.emoji_events, trophyCount.toString(), const Color(0xFFE9B63B)),
        const SizedBox(width: 15),
        _buildStat(Icons.local_fire_department, streakCount.toString(), Colors.grey),
      ],
    );
  }

  Widget _buildStat(IconData icon, String value, Color color) {
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