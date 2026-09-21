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

  void _showComprehensiveLockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        title: Center(
          child: Text(
            "Grand Master Credential Locked",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Text(
          "Complete Alphabets, Numbers, and Phrases to unlock your Comprehensive Sign Language Proficiency certificate.",
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
                  Navigator.of(dialogCtx).pop();
                  Navigator.of(context).pop();
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

  void _showCategoryLockDialog(BuildContext context, String categoryTitle) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
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
          "You need to finish all lessons in $categoryTitle before downloading a certificate.",
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
                  Navigator.of(dialogCtx).pop();
                  Navigator.of(context).pop();
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

  Future<void> _handleComprehensiveDownload(
    BuildContext context,
    AchievementsViewModel viewModel,
  ) async {
    if (!viewModel.isComprehensiveEligible) {
      _showComprehensiveLockDialog(context);
      return;
    }

    final userVM = context.read<UserViewModel>();
    final userId = userVM.user?.id;

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User ID not available. Please login again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await viewModel.downloadCertificate('comprehensive', userId);
    if (!context.mounted) return;

    if (viewModel.downloadErrorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.downloadErrorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Comprehensive certificate downloaded successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _handleComprehensivePreview(
    BuildContext context,
    AchievementsViewModel viewModel,
  ) async {
    if (!viewModel.isComprehensiveEligible) {
      _showComprehensiveLockDialog(context);
      return;
    }

    final userVM = context.read<UserViewModel>();
    final userId = userVM.user?.id;

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User ID not available. Please login again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await viewModel.previewCertificate('comprehensive', userId);
    if (!context.mounted) return;

    if (viewModel.downloadErrorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.downloadErrorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleCategoryPreview(
    BuildContext context,
    AchievementsViewModel viewModel,
    String categoryId,
    String categoryTitle,
  ) async {
    final userVM = context.read<UserViewModel>();
    final userId = userVM.user?.id;

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User ID not available. Please login again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await viewModel.previewCertificate(categoryId, userId);
    if (!context.mounted) return;

    if (viewModel.downloadErrorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.downloadErrorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleCategoryDownload(
    BuildContext context,
    AchievementsViewModel viewModel,
    String categoryId,
    String categoryTitle,
    bool isCompleted,
  ) async {
    if (!isCompleted) {
      _showCategoryLockDialog(context, categoryTitle);
      return;
    }

    final userVM = context.read<UserViewModel>();
    final userId = userVM.user?.id;

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User ID not available. Please login again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await viewModel.downloadCertificate(categoryId, userId);
    if (!context.mounted) return;

    if (viewModel.downloadErrorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.downloadErrorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Certificate for $categoryTitle downloaded successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AchievementsViewModel>();

    return Scaffold(
      backgroundColor: const Color(0XFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0XFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Grand Master Credential Card
                  GrandMasterCredentialCard(
                    completedTracks: viewModel.completedTracksCount,
                    totalTracks: viewModel.totalTracksCount,
                    completedLessons: viewModel.totalCompletedLessonsCount,
                    totalLessons: viewModel.totalLessonsCount,
                    isUnlocked: viewModel.isComprehensiveEligible,
                    isDownloading:
                        viewModel.isDownloadingCategory('comprehensive'),
                    isPreviewing:
                        viewModel.isPreviewingCategory('comprehensive'),
                    onPreview: () =>
                        _handleComprehensivePreview(context, viewModel),
                    onDownload: () =>
                        _handleComprehensiveDownload(context, viewModel),
                  ),
                  SizedBox(height: 24.h),

                  // Section Header:
                  Text(
                    "CATEGORY CERTIFICATES (${viewModel.completedTracksCount}/${viewModel.totalTracksCount})",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF475569),
                      letterSpacing: 0.6,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Category Certificates
                  ...viewModel.categories.map((category) {
                    final bool isCompleted =
                        category.completedLessons >= category.totalLessons &&
                            category.totalLessons > 0;

                    return CertificateCard(
                      categoryName: category.title,
                      completedLessons: category.completedLessons,
                      totalLessons: category.totalLessons,
                      completedDate: viewModel.getCompletionDate(category.id),
                      isDownloading:
                          viewModel.isDownloadingCategory(category.id),
                      isPreviewing: viewModel.isPreviewingCategory(category.id),
                      onPreview: () => _handleCategoryPreview(
                        context,
                        viewModel,
                        category.id,
                        category.title,
                      ),
                      onDownload: () => _handleCategoryDownload(
                        context,
                        viewModel,
                        category.id,
                        category.title,
                        isCompleted,
                      ),
                    );
                  }),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
    );
  }
}
