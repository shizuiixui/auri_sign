import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/features/homepage/presentation/widgets/homepage_helpers.dart';
import '/core/widgets/continue_lesson_card.dart';
import 'package:auri_sign/features/profile/viewmodels/notification_schedule_view_model.dart';
import 'package:auri_sign/features/notifications/presentation/viewmodels/notification_center_view_model.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onProfileTap;

  const HomePage({super.key, required this.onProfileTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final user = userVM.user;
    final scheduleVM = context.watch<NotificationScheduleViewModel>();
    final centerVM = context.read<NotificationCenterViewModel>();
    final isAlarmEnabled = scheduleVM.schedule != null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      centerVM.catchUp8AMNotification(isAlarmEnabled);
    });

    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      body: userVM.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            )
          : CustomScrollView(
              slivers: [
                // Header Widget
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

                // Carousel Section
                const SliverToBoxAdapter(child: HomeCarouselSection()),

                // Daily Tracker Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 10.h),
                        child: Text(
                          "Daily Tracker",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          children: [
                            const DailyTrackerItem(
                              day: "Mon",
                              isCompleted: false,
                            ),
                            SizedBox(width: 12.w),
                            const DailyTrackerItem(
                              day: "Tue",
                              isCompleted: false,
                            ),
                            SizedBox(width: 12.w),
                            const DailyTrackerItem(
                              day: "Wed",
                              isCompleted: false,
                            ),
                            SizedBox(width: 12.w),
                            const DailyTrackerItem(
                              day: "Thu",
                              isCompleted: false,
                            ),
                            SizedBox(width: 12.w),
                            const DailyTrackerItem(
                              day: "Fri",
                              isCompleted: false,
                            ),
                            SizedBox(width: 12.w),
                            const DailyTrackerItem(
                              day: "Sat",
                              isCompleted: false,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
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
                      const CategorySectionCard(
                        title: "Alphabets",
                        color: Color(0xFFE9B63B), // Yellow
                        imagePath:
                            "assets/images/homepage_FSL_img/letter_A_FSL.png",
                        bigDisplayChar: "A",
                      ),
                      SizedBox(height: 20.h),
                      const CategorySectionCard(
                        title: "Numbers",
                        color: Color(0xFF3B82F6), // Blue
                        imagePath:
                            "assets/images/homepage_FSL_img/number_1_FSL.png",
                        bigDisplayChar: "1",
                      ),
                      SizedBox(height: 20.h),
                      const CategorySectionCard(
                        title: "Common Words",
                        color: Color(0xFFEF4444), // Red
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

class HomeCarouselSection extends StatefulWidget {
  const HomeCarouselSection({super.key});

  @override
  State<HomeCarouselSection> createState() => _HomeCarouselSectionState();
}

class _HomeCarouselSectionState extends State<HomeCarouselSection> {
  double _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  final List<String> imgList = [
    "assets/images/homepage_FSL_img/letter_A_FSL.png",
    "assets/images/homepage_FSL_img/number_1_FSL.png",
    "assets/images/homepage_FSL_img/common_words_FSL.png",
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPage = _pageController.page!;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleLessonTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/category_alphabets');
        break;
      case 1:
        Navigator.pushNamed(context, '/category_numbers');
        break;
      case 2:
        Navigator.pushNamed(context, '/category_common_words');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Text(
            "Continue Lessons",
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 150.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: imgList.length,
            itemBuilder: (context, index) {
              double relativePosition = index - _currentPage;
              return Transform(
                transform: Matrix4.identity()
                  ..translate(relativePosition * -20.0)
                  ..scale(1 - (relativePosition.abs() * 0.1)),
                child: Opacity(
                  opacity: (1 - (relativePosition.abs() * 0.3)).clamp(0.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => _handleLessonTap(index),
                      child: ContinueLessonCard(
                        title: ["Alphabets", "Numbers", "Common Words"][index],
                        progress: 0,
                        color: [
                          const Color(0xFFE9B63B), // Yellow
                          const Color(0xFF3B82F6), // Blue
                          const Color(0xFFEF4444), // Red
                        ][index],
                        imagePath: imgList[index],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 6.h),
        // Pagination Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(imgList.length, (index) {
            bool isActive = _currentPage.round() == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 6.h,
              width: isActive ? 20.w : 6.w,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF3B82F6) : Colors.grey[300],
                borderRadius: BorderRadius.circular(3.r),
              ),
            );
          }),
        ),
      ],
    );
  }
}
