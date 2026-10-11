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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<AchievementsViewModel>();
      await vm.fetchAchievements();
      if (mounted && vm.completedTracksCount == 0) {
        _showNoCertificateDialog(context);
      }
    });
  }

  void _showNoCertificateDialog(BuildContext context, {String? categoryTitle}) {
    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Title and Close 'X' Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24), // Spacer for centering
                  Expanded(
                    child: Text(
                      "No Certificate Available Yet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                        fontFamily: 'Inter',
                        color: const Color(0xFF1E293B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(dialogCtx).pop(),
                    child: Icon(
                      Icons.close,
                      size: 22.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Center Gold Seal Icon
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.workspace_premium,
                    size: 38.sp,
                    color: const Color(0xFFFFB800),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Message Body
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  categoryTitle != null
                      ? "You need to finish all lessons in $categoryTitle to unlock this certificate!"
                      : "You need to complete all lessons in at least one category to unlock your first accredited certificate!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 13.5.sp,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Start Learning Now Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB800),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  onPressed: () {
                    AppRouter.navTabIndex.value = 0;
                    Navigator.of(dialogCtx).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Start Learning Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleComprehensiveDownload(
    BuildContext context,
    AchievementsViewModel viewModel,
  ) async {
    if (!viewModel.isComprehensiveEligible) {
      _showNoCertificateDialog(
        context,
        categoryTitle: "Alphabets, Numbers, and Phrases",
      );
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
      _showNoCertificateDialog(
        context,
        categoryTitle: "Alphabets, Numbers, and Phrases",
      );
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
      _showNoCertificateDialog(context, categoryTitle: categoryTitle);
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
