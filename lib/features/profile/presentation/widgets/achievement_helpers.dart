import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// achievementProgressCard
class AchievementProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String subtitle;
  final bool isExpanded;
  final VoidCallback onTap;

  const AchievementProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.subtitle,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isExpanded ? 0 : 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFFFB800), width: 1.5.w),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 24.sp,
                ),
              ],
            ),
            SizedBox(height: 15.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8.h,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFFFB800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// expandedLessonsList
class ExpandedLessonsList extends StatelessWidget {
  final int totalLessons;
  final int completedLessons;

  const ExpandedLessonsList({
    super.key,
    required this.totalLessons,
    required this.completedLessons,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> lessons = [];
    for (int i = 1; i <= totalLessons; i++) {
      lessons.add(const VerticalStepLine());
      if (i <= completedLessons) {
        lessons.add(
          ActiveLessonStep(
            title: "Lesson $i Completed",
            subtitle: "Completed",
            progress: 1.0,
            number: i,
          ),
        );
      } else {
        lessons.add(InactiveLessonStep(title: "Lesson $i Locked", number: i));
      }
    }
    lessons.add(SizedBox(height: 16.h));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(children: lessons),
    );
  }
}

// verticalStepLine
class VerticalStepLine extends StatelessWidget {
  const VerticalStepLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 1.5.w,
      color: Colors.grey.shade400,
    );
  }
}

// activeLessonStep
class ActiveLessonStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final int number;

  const ActiveLessonStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFFFB800), width: 1.5.w),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          LessonCoin(isActive: true, number: number),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4.h,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFB800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// inactiveLessonStep
class InactiveLessonStep extends StatelessWidget {
  final String title;
  final int number;

  const InactiveLessonStep({
    super.key,
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.5.w),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          LessonCoin(isActive: false, number: number),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lessonCoin
class LessonCoin extends StatelessWidget {
  final bool isActive;
  final int number;

  const LessonCoin({super.key, required this.isActive, required this.number});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30.r,
      height: 30.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/your_coin_image.png',
            width: 30.r,
            height: 30.r,
            fit: BoxFit.contain,
            color: isActive ? null : Colors.grey,
            colorBlendMode: isActive ? null : BlendMode.saturation,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? const Color(0xFFDAA520)
                      : Colors.grey.shade300,
                ),
              );
            },
          ),
          Text(
            number.toString(),
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// Certificate Card Widget
class CertificateCard extends StatelessWidget {
  final String categoryName;
  final int completedLessons;
  final int totalLessons;
  final VoidCallback onDownload;
  final bool isDownloading;

  const CertificateCard({
    super.key,
    required this.categoryName,
    required this.completedLessons,
    required this.totalLessons,
    required this.onDownload,
    this.isDownloading = false,
  });

  @override
  Widget build(BuildContext context) {
    // checkIfCategoryIsFullyCompleted
    bool isCompleted = completedLessons >= totalLessons && totalLessons > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // leftSideInfo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.orange.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isCompleted
                          ? const Color(0xFFFFB800).withOpacity(0.5)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    categoryName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? const Color(0xFFB8860B) : Colors.grey.shade600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "$completedLessons/$totalLessons lessons completed",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  isCompleted ? "Completed" : "Not yet completed",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isCompleted ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          // Button
          _ActionButton(
            text: isDownloading ? "Downloading..." : "Download",
            icon: isCompleted ? Icons.download_rounded : Icons.lock_outline,
            color: isCompleted ? const Color(0xFFFFB800) : Colors.grey.shade400,
            textColor: Colors.white,
            onPressed: isDownloading ? null : onDownload,
            isLoading: isDownloading,
          ),
        ],
      ),
    );
  }
}

// actionButtonHelperForCertificates
class _ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _ActionButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.textColor,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? SizedBox(
                width: 16.r,
                height: 16.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 18.sp,
                    color: textColor,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
