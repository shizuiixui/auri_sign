import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/features/homepage/presentation/widgets/homepage_helpers.dart';
import '/features/homepage/presentation/widgets/daily_tracker.dart';
import 'package:auri_sign/features/profile/viewmodels/notification_schedule_view_model.dart';
import 'package:auri_sign/features/notifications/presentation/viewmodels/notification_center_view_model.dart';
import 'package:auri_sign/features/lessons/presentation/screens/category_details_page.dart';
import '/../features/lessons/presentation/viewmodels/category_view_model.dart';
import 'package:auri_sign/features/profile/viewmodels/streak_view_model.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onProfileTap;

  const HomePage({super.key, required this.onProfileTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Navigation logic
  void _handleCategoryTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CategoryDetailsPage(
              title: "Alphabets",
              apiCategoryName: "Alphabets",
              webCategorySlug: "alphabets",
              description:
                  "Learn the 26 letters of the Filipino Sign Language alphabet.",
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CategoryDetailsPage(
              title: "Numbers",
              apiCategoryName: "Numbers",
              webCategorySlug: "numbers",
              description:
                  "Learn numbers from 1 to 100 in Filipino Sign Language.",
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CategoryDetailsPage(
              title: "Common Words",
              apiCategoryName: "Phrases/Words",
              webCategorySlug: "phrases-words",
              description:
                  "Learn common phrases and words in Filipino Sign Language.",
            ),
          ),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final scheduleVM = context.read<NotificationScheduleViewModel>();
      final centerVM = context.read<NotificationCenterViewModel>();

      if (scheduleVM.isLoading) {
        await scheduleVM.ensureScheduleInitialized();
      }
      final isAlarmEnabled = scheduleVM.schedule != null;

      await centerVM.catchUp8AMNotification(isAlarmEnabled);
      if (mounted) {
        context.read<CategoryViewModel>().fetchAllCategoriesSummary();
        context.read<StreakViewModel>().fetchStreakInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final user = userVM.user;

    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      body: userVM.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            )
          : CustomScrollView(
              slivers: [
                // 1. Header Widget
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 10.h),
                      child: HomeHeader(
                        firstName: user?.firstName ?? "Guest",
                        profilePicture: user?.profilePicture,
                        onProfileTap: widget.onProfileTap,
                      ),
                    ),
                  ),
                ),

                // 2. Carousel Section
                const SliverToBoxAdapter(child: HomeCarouselSection()),

                // 3. Daily Tracker Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 10.h, 0.w, 10.h),
                    child: const DailyTrackerSection(),
                  ),
                ),

                // 4. Categories Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 4.h,
                    ),
                    child: Text(
                      "Category Sections",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 5. Category List
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 15.h,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      CategorySectionCard(
                        title: "Alphabets",
                        color: const Color(0xFFE9B63B), // Yellow
                        onTap: () => _handleCategoryTap(0),
                        imagePath:
                            "assets/images/homepage_FSL_img/letter_A_FSL.png",
                        bigDisplayChar: "A",
                      ),
                      SizedBox(height: 20.h),
                      CategorySectionCard(
                        title: "Numbers",
                        color: const Color(0xFF3B82F6), // Blue
                        onTap: () => _handleCategoryTap(1),
                        imagePath:
                            "assets/images/homepage_FSL_img/number_1_FSL.png",
                        bigDisplayChar: "1",
                      ),
                      SizedBox(height: 20.h),
                      CategorySectionCard(
                        title: "Common Words",
                        color: const Color(0xFFEF4444), // Red
                        onTap: () => _handleCategoryTap(2),
                        imagePath:
                            "assets/images/homepage_FSL_img/common_words_FSL.png",
                        bigDisplayIcon: Icons.favorite,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }
}
