import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/widgets/user_stats.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/notifications/presentation/viewmodels/notification_center_view_model.dart';
import 'package:auri_sign/features/notifications/presentation/screens/notifications_page.dart';
import '/core/widgets/continue_lesson_card.dart';
import 'package:auri_sign/features/lessons/presentation/screens/category_details_page.dart';
import '/../features/lessons/presentation/viewmodels/category_view_model.dart';
import 'package:auri_sign/features/lessons/data/models/category_progress_model.dart';
import 'package:auri_sign/features/homepage/presentation/widgets/daily_tracker.dart';

class HomeHeader extends StatelessWidget {
  final String firstName;
  final String? profilePicture;
  final VoidCallback onProfileTap;

  const HomeHeader({
    super.key,
    required this.firstName,
    this.profilePicture,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    String initial = "U";
    if (firstName.isNotEmpty) {
      initial = firstName[0].toUpperCase();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFB800).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFFFB800),
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            Padding(
              padding: EdgeInsets.only(top: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello,",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "$firstName!",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Consumer<NotificationCenterViewModel>(
                builder: (context, notificationVM, child) {
                  final unreadCount = notificationVM.unreadCount;

                  return IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.notifications_outlined, size: 24.sp),
                        if (unreadCount > 0)
                          Positioned(
                            right: -2,
                            top: -4,
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16.w,
                                minHeight: 16.w,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 9
                                      ? '9+'
                                      : unreadCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        Text(
          "Your Smart AI Sign Language\nLearning Companion",
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 16.h),

        const UserStatsRow(),
      ],
    );
  }
}

class CategorySectionCard extends StatelessWidget {
  final String title;
  final Color color;
  final String imagePath;
  final String? bigDisplayChar;
  final IconData? bigDisplayIcon;
  final VoidCallback onTap;

  const CategorySectionCard({
    super.key,
    required this.title,
    required this.color,
    required this.imagePath,
    required this.onTap,
    this.bigDisplayChar,
    this.bigDisplayIcon,
  });

  @override
  Widget build(BuildContext context) {
    bool hasBigElement = bigDisplayChar != null || bigDisplayIcon != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            if (bigDisplayChar != null)
              Positioned(
                right: 20.w,
                bottom: 5.h,
                child: Text(
                  bigDisplayChar!,
                  style: TextStyle(
                    fontSize: 140.sp,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Unna',
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            if (bigDisplayIcon != null)
              Positioned(
                right: 3.w,
                bottom: 10.h,
                child: Icon(
                  bigDisplayIcon,
                  size: 100.sp,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: hasBigElement ? 65.0.w : 0.0,
                    ),
                    child: Image.asset(
                      imagePath,
                      height: 60.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyTrackerItem extends StatelessWidget {
  final String day;
  final bool isCompleted;

  const DailyTrackerItem({
    super.key,
    required this.day,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4.h),
          if (isCompleted)
            Container(
              height: 24.w,
              width: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(Icons.check, size: 16.sp, color: Colors.white),
            )
          else
            SizedBox(height: 24.w),
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

  void _handleCarouselTap(int index) {
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
                  "Learn each letter of Filipino Sign Language and practice your gestures.",
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
                  "Learn how to sign numbers in Filipino Sign Language.",
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
              description: "Learn everyday phrases and common words in FSL.",
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoryViewModel>();

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
              String apiCategoryName = [
                "Alphabets",
                "Numbers",
                "Phrases/Words",
              ][index];
              int completed = 0;
              int total = 0;

              if (vm.categorySummaries.isNotEmpty) {
                final summary = vm.categorySummaries.firstWhere(
                  (s) => s.category == apiCategoryName,
                  orElse: () => CategorySummary(
                    category: apiCategoryName,
                    totalLessons: 0,
                    completedLessons: 0,
                    isCompleted: false,
                  ),
                );

                completed = summary.completedLessons;
                total = summary.totalLessons;
              }

              return Transform(
                transform: Matrix4.identity()
                  ..translate(relativePosition * -20.0)
                  ..scale(1 - (relativePosition.abs() * 0.1)),
                child: Opacity(
                  opacity: (1 - (relativePosition.abs() * 0.3)).clamp(0.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => _handleCarouselTap(index),
                      child: ContinueLessonCard(
                        title: ["Alphabets", "Numbers", "Common Words"][index],
                        completedLessons: completed,
                        totalLessons: total,
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
