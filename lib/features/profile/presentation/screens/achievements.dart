import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/profile/presentation/widgets/achievement_helpers.dart'; 
import 'package:auri_sign/features/profile/viewmodels/achievements_view_model.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AchievementsViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Achievements",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            ...viewModel.categories.map((category) {
              final isExpanded = viewModel.isExpanded(category.id);

              return Column(
                children: [
                  AchievementProgressCard(
                    title: category.title,
                    progress: category.progress,
                    subtitle: category.subtitle,
                    isExpanded: isExpanded,
                    onTap: () => viewModel.toggleExpanded(category.id),
                  ),
                  if (isExpanded)
                    ExpandedLessonsList(
                      totalLessons: category.totalLessons,
                      completedLessons: category.completedLessons,
                    ),
                ],
              );
            }),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: viewModel.isCertificateUnlocked
                    ? const Color(0xFFFFB800)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Download Certificate",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      viewModel.isCertificateUnlocked
                          ? Icons.download
                          : Icons.lock_outline,
                      color: Colors.white.withOpacity(0.9),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}