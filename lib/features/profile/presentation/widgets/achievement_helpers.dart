import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

// Grand Master Credential Top Card Widget
class GrandMasterCredentialCard extends StatelessWidget {
  final int completedTracks;
  final int totalTracks;
  final int completedLessons;
  final int totalLessons;
  final bool isUnlocked;
  final bool isDownloading;
  final bool isPreviewing;
  final VoidCallback onDownload;
  final VoidCallback onPreview;

  const GrandMasterCredentialCard({
    super.key,
    required this.completedTracks,
    required this.totalTracks,
    required this.completedLessons,
    required this.totalLessons,
    required this.isUnlocked,
    required this.isDownloading,
    this.isPreviewing = false,
    required this.onDownload,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _CrownIcon(),
                SizedBox(width: 5.w),
                Text(
                  "GRAND MASTER CREDENTIAL",
                  style: TextStyle(
                    color: const Color(0xFFF59E0B),
                    fontWeight: FontWeight.w800,
                    fontSize: 10.sp,
                    letterSpacing: 0.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Comprehensive Sign Language Proficiency",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$completedTracks/$totalTracks Learning Tracks Completed ($completedLessons/$totalLessons Lessons)",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      isUnlocked
                          ? "All tracks completed"
                          : "Complete Alphabets, Numbers, and Phrases to unlock",
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF64748B),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isUnlocked) ...[
                    _PreviewButton(
                      isLoading: isPreviewing,
                      onPressed: onPreview,
                    ),
                    SizedBox(width: 6.w),
                  ],
                  _CertificateActionButton(
                    text: "Download",
                    isUnlocked: isUnlocked,
                    isLoading: isDownloading,
                    onPressed: onDownload,
                  ),
                ],
              ),
            ],
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
  final String completedDate;
  final VoidCallback onDownload;
  final VoidCallback onPreview;
  final bool isDownloading;
  final bool isPreviewing;

  const CertificateCard({
    super.key,
    required this.categoryName,
    required this.completedLessons,
    required this.totalLessons,
    this.completedDate = '',
    required this.onDownload,
    required this.onPreview,
    this.isDownloading = false,
    this.isPreviewing = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted =
        completedLessons >= totalLessons && totalLessons > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Category Pill + Completed Badge across the full card width
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8.w,
            runSpacing: 4.h,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: const Color(0xFFF59E0B),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD97706),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              if (isCompleted)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      size: 16.sp,
                      color: const Color(0xFF00B074),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      "Completed",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00B074),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 8.h),

          // Row 2: Subtitle & Status on the left, Buttons on the right
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$completedLessons/$totalLessons lessons completed",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      isCompleted
                          ? (completedDate.isNotEmpty
                              ? "Completed on $completedDate"
                              : "Completed")
                          : "In progress",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted) ...[
                    _PreviewButton(
                      isLoading: isPreviewing,
                      onPressed: onPreview,
                    ),
                    SizedBox(width: 6.w),
                  ],
                  _CertificateActionButton(
                    text: "Download",
                    isUnlocked: isCompleted,
                    isLoading: isDownloading,
                    onPressed: onDownload,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CertificateActionButton extends StatelessWidget {
  final String text;
  final bool isUnlocked;
  final bool isLoading;
  final VoidCallback onPressed;

  const _CertificateActionButton({
    required this.text,
    required this.isUnlocked,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isUnlocked ? const Color(0xFFFFB800) : const Color(0xFFFFD866);

    return SizedBox(
      height: 36.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w),
        ),
        onPressed: isLoading ? null : onPressed,
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
                  const _DownloadIcon(color: Colors.white),
                  SizedBox(width: 5.w),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _PreviewButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF64748B), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 14.r,
                height: 14.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF475569)),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 15.sp,
                    color: const Color(0xFF475569),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Preview",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF475569),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CrownIcon extends StatelessWidget {
  const _CrownIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''<svg width="13" height="11" viewBox="0 0 24 20" fill="#F59E0B">
        <path d="M2 17h20v3H2v-3zm0-3.5L5.5 4l6.5 6 6.5-6L22 13.5H2z"/>
      </svg>''',
    );
  }
}

class _DownloadIcon extends StatelessWidget {
  final Color color;

  const _DownloadIcon({this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
        <polyline points="14 2 14 8 20 8"></polyline>
        <line x1="12" y1="18" x2="12" y2="12"></line>
        <polyline points="9 15 12 18 15 15"></polyline>
      </svg>''',
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
