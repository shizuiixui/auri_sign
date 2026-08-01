import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '/core/widgets/continue_lesson_card.dart';
import 'package:auri_sign/features/lessons/presentation/viewmodels/category_view_model.dart';
import 'package:auri_sign/features/lessons/data/models/category_progress_model.dart';
import 'package:auri_sign/features/lessons/presentation/screens/category_details_page.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryViewModel>().fetchAllCategoriesSummary();
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
          style: TextStyle(fontSize: 14.sp, fontFamily: 'Inter'),
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

class ProfileSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? switchActiveColor;
  final Color? switchActiveTrackColor;
  final Color? switchInactiveThumbColor;
  final Color? switchInactiveTrackColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;

  const ProfileSwitchTile({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.onChanged,
    this.titleStyle,
    this.subtitleStyle,
    this.switchActiveColor,
    this.switchActiveTrackColor,
    this.switchInactiveThumbColor,
    this.switchInactiveTrackColor,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.margin,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border.all(color: borderColor ?? Colors.grey.shade200),
        borderRadius: borderRadius ?? BorderRadius.circular(30),
      ),
      child: ListTile(
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(horizontal: 20),
        title: Text(
          title,
          style:
              titleStyle ?? const TextStyle(fontSize: 15, fontFamily: 'Inter'),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style:
                    subtitleStyle ??
                    TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Inter',
                    ),
              ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: switchActiveColor ?? const Color(0xFFFFB800),
          activeTrackColor: switchActiveTrackColor,
          inactiveThumbColor: switchInactiveThumbColor,
          inactiveTrackColor: switchInactiveTrackColor,
        ),
      ),
    );
  }
}
