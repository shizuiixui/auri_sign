import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/profile/presentation/widgets/achievement_helpers.dart';
import 'package:auri_sign/features/profile/viewmodels/achievements_view_model.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AchievementsViewModel>().fetchAchievements();
    });
  }

  // showLockDialogWarning
  void _showLockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Center(
          child: Text(
            "No Certificate Available Yet",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        content: const Text(
          "You need to finish this category before downloading a certificate.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Go To Lessons",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AchievementsViewModel>();

    // countCompletedCategoriesForHeader
    int completedCategories = viewModel.categories
        .where(
          (c) => c.completedLessons >= c.totalLessons && c.totalLessons > 0,
        )
        .length;

    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0XFFF8F8F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Download Certificates",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB800)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Completed categories are clickable. Incomplete categories are disabled.",
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Completed categories: $completedCategories/${viewModel.categories.length}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ...viewModel.categories.map((category) {
                    return CertificateCard(
                      categoryName: category.title,
                      completedLessons: category.completedLessons,
                      totalLessons: category.totalLessons,
                      onDownload: () {
                        if (category.completedLessons < category.totalLessons ||
                            category.totalLessons == 0) {
                          _showLockDialog(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Downloading certificate for ${category.title}...",
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }),

                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }
}
