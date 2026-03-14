import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/profile/viewmodels/streak_view_model.dart';

class DailyTrackerSection extends StatelessWidget {
  const DailyTrackerSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Grab the dynamic data from the ViewModel
    final streakVM = context.watch<StreakViewModel>();
    final recentActivity = streakVM.streakInfo?.recentActivity ?? [];

    // Generate the current week
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday; // 1 = Mon, 7 = Sun
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));

    List<DateTime> weekDays = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    final dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daily Tracker",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 70.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              DateTime dayDate = weekDays[index];

              bool hasActivity = recentActivity.any((activity) {
                if (activity.date == null) return false;

                DateTime backendDate = activity.date!.toLocal();

                return backendDate.year == dayDate.year &&
                    backendDate.month == dayDate.month &&
                    backendDate.day == dayDate.day &&
                    activity.lessonsCompleted > 0;
              });

              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: DailyTrackerItem(
                  day: dayNames[index],
                  isCompleted: hasActivity,
                ),
              );
            },
          ),
        ),
      ],
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
