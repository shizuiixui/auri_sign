import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/features/homepage/presentation/widgets/homepage_helpers.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onProfileTap;

  const HomePage({super.key, required this.onProfileTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  // Updated Order: Alphabets, Numbers, Common Words
  final List<String> imgList = [
    "assets/images/homepage_FSL_img/letter_A_FSL.png",
    "assets/images/homepage_FSL_img/number_1_FSL.png",
    "assets/images/homepage_FSL_img/common_words_FSL.png",
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final user = userVM.user;

    String initial = "U";
    if (user?.firstName != null && user!.firstName!.isNotEmpty) {
      initial = user.firstName![0].toUpperCase();
    }

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
                      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello,",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                user?.firstName ?? "Guest",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: GestureDetector(
                              onTap: widget.onProfileTap,
                              child: Container(
                                width: 50.w,
                                height: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFFB800,
                                      ).withOpacity(0.3),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Carousel Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 10.h,
                        ),
                        child: Text(
                          "Continue Lessons",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
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
                                opacity: (1 - (relativePosition.abs() * 0.3))
                                    .clamp(0.0, 1.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ContinueLessonCard(
                                    title: [
                                      "Alphabets",
                                      "Numbers",
                                      "Common Words",
                                    ][index],
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
                              color: isActive
                                  ? const Color(0xFF3B82F6)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

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

                // Category Sections
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      CategorySectionCard(
                        title: "Alphabets",
                        color: const Color(0xFFE9B63B), // Yellow
                        imagePath: imgList[0],
                        bigDisplayChar: "A",
                      ),
                      SizedBox(height: 20.h),
                      CategorySectionCard(
                        title: "Numbers",
                        color: const Color(0xFF3B82F6), // Blue
                        imagePath: imgList[1],
                        bigDisplayChar: "1",
                      ),
                      SizedBox(height: 20.h),
                      CategorySectionCard(
                        title: "Common Words",
                        color: const Color(0xFFEF4444), // Red
                        imagePath: imgList[2],
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
