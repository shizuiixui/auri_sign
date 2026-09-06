import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/profile/presentation/widgets/achievement_helpers.dart';
import 'package:auri_sign/features/profile/viewmodels/achievements_view_model.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:auri_sign/core/routes/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        title: Center(
          child: Text(
            "No Certificate Available Yet",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Text(
          "You need to finish this category before downloading a certificate.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13.sp,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
            child: SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  AppRouter.navTabIndex.value = 0;
                  Navigator.of(context).pop();
                  Navigator.of(this.context).pop();
                },
                child: Text(
                  "Go To Lessons",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
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

    // Count Completed Categories
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
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Download Certificates",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB800)),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Completed categories are clickable. Incomplete categories are disabled.",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade700,
                      height: 1.4,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Completed categories: $completedCategories/${viewModel.categories.length}",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 16.h),

                  ...viewModel.categories.map((category) {
                    return CertificateCard(
                      categoryName: category.title,
                      completedLessons: category.completedLessons,
                      totalLessons: category.totalLessons,
                      isDownloading: viewModel.isDownloading,

                      onDownload: () async {
                        if (category.completedLessons < category.totalLessons ||
                            category.totalLessons == 0) {
                          _showLockDialog(context);
                        } else {
                          final userVM = context.read<UserViewModel>();
                          final userId = userVM.user?.id;

                          if (userId != null) {
                            await viewModel.downloadCertificate(
                              category.id,
                              userId,
                            );

                            if (!context.mounted) return;

                            if (viewModel.downloadErrorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    viewModel.downloadErrorMessage!,
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Certificate for ${category.title} downloaded successfully!",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "User ID not available. Please login again.",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    );
                  }),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
    );
  }
}
