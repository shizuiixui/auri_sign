import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/widgets/continue_lesson_card.dart';

class CompletedLessonsCarousel extends StatefulWidget {
  const CompletedLessonsCarousel({super.key});

  @override
  State<CompletedLessonsCarousel> createState() =>
      _CompletedLessonsCarouselState();
}

class _CompletedLessonsCarouselState extends State<CompletedLessonsCarousel> {
  late PageController _pageController;
  double _currentPage = 0.0;

  // Alphabets, Numbers, Common Words
  final List<String> imgList = [
    "assets/images/homepage_FSL_img/letter_A_FSL.png",
    "assets/images/homepage_FSL_img/number_1_FSL.png",
    "assets/images/homepage_FSL_img/common_words_FSL.png",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
          padding: EdgeInsets.only(bottom: 10.h, left: 4.w),
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
                  ..translate(relativePosition * -20.0.w)
                  ..scale(1 - (relativePosition.abs() * 0.1)),
                child: Opacity(
                  opacity: (1 - (relativePosition.abs() * 0.3)).clamp(0.0, 1.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0.w),
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
        SizedBox(height: 10.h),
      ],
    );
  }
}

class ProfileSectionHeader extends StatelessWidget {
  final String title;

  const ProfileSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h, left: 4.w),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuTile({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
        title: Text(
          title,
          style: TextStyle(fontSize: 15.sp, fontFamily: 'Inter'),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14.sp,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
