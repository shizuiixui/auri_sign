import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:auri_sign/features/profile/viewmodels/streak_view_model.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StreakViewModel>().fetchStreakInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StreakViewModel>();
    final streak = vm.streakInfo;

    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0XFFF8F8F8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Your Streak",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      body: vm.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            )
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : streak == null
          ? const Center(child: Text("No streak data available."))
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner
                        _buildBlueBanner(streak),
                        SizedBox(height: 20.h),

                        // Streak Status Card
                        _buildStreakStatusCard(streak),
                        SizedBox(height: 20.h),

                        // Activity Card
                        _buildActivityCard(streak),
                        SizedBox(height: 20.h),

                        // Recent Activity Card
                        _buildRecentActivityCard(streak),
                        SizedBox(height: 20.h),

                        // Milestones Card
                        if (streak.milestones.isNotEmpty)
                          _buildMilestonesCard(streak),

                        SizedBox(height: 20.h),

                        // Tip Banner
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7FA),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lightbulb,
                                color: Color(0xFFE9B63B),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  "Tip: Complete a lesson today to maintain your streak!",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.teal[800],
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildBlueBanner(dynamic streak) {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday == 7 ? 0 : now.weekday; // Make Sunday 0
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday));

    List<DateTime> weekDays = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final recentActivity = streak.recentActivity ?? [];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E74FD),
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: -20.w,
            bottom: -20.h,
            child: Icon(
              Icons.local_fire_department,
              size: 150.sp,
              color: Colors.orange.withOpacity(0.8),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${streak.currentStreak}",
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                Text(
                  "Day Streak",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 25.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    DateTime dayDate = weekDays[index];

                    bool isActive = recentActivity.any((activity) {
                      if (activity.date == null) return false;
                      DateTime backendDate = activity.date!.toLocal();
                      return backendDate.year == dayDate.year &&
                          backendDate.month == dayDate.month &&
                          backendDate.day == dayDate.day &&
                          activity.lessonsCompleted > 0;
                    });

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          days[index],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isActive ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          height: 28.r,
                          width: 28.r,
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: isActive
                              ? Icon(
                                  Icons.check,
                                  size: 18.sp,
                                  color: const Color(0xFF1E74FD),
                                )
                              : null,
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakStatusCard(dynamic streak) {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: const Color(0xFF1E74FD),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "Streak Status",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Streak",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis, // Safely truncates if too long
                    ),
                    Text(
                      "${streak.currentStreak} days",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E74FD),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Longest Streak",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${streak.longestStreak} days",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFB800),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            "Status",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: streak.isActive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              streak.isActive ? "Active" : "Inactive",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(dynamic streak) {
    String formattedDate = streak.lastActivityDate != null
        ? DateFormat('MMM d, yyyy').format(streak.lastActivityDate!.toLocal())
        : "Never";
    String daysSince = streak.daysSinceLastActivity == 0
        ? "Today"
        : streak.daysSinceLastActivity == 1
        ? "Yesterday"
        : "${streak.daysSinceLastActivity} days ago";

    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.green, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                "Activity",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildActivityRow("Last Activity", formattedDate),
          SizedBox(height: 10.h),
          _buildActivityRow("Days Since Last Activity", daysSince),
          SizedBox(height: 10.h),
          _buildActivityRow(
            "Completed Today",
            streak.hasActivityToday ? "✅ Yes" : "❌ Not yet",
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(dynamic streak) {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Activity",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 15.h),
          if (streak.recentActivity.isEmpty)
            Text(
              "No recent activity.",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            )
          else
            ...streak.recentActivity.map<Widget>((activity) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.date != null
                          ? DateFormat(
                              'MMM d, yyyy',
                            ).format(activity.date!.toLocal())
                          : "Unknown",
                      style: TextStyle(fontSize: 14.sp, fontFamily: 'Inter'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E74FD),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        "${activity.lessonsCompleted} ${activity.lessonsCompleted == 1 ? 'lesson' : 'lessons'}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildMilestonesCard(dynamic streak) {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: const Color(0xFFFFB800),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "Milestones Achieved",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          ...streak.milestones.map<Widget>((m) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${m.streakCount} Days",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      m.achievedAt != null
                          ? DateFormat(
                              'MMM d, yyyy',
                            ).format(m.achievedAt!.toLocal())
                          : "",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
                Icon(
                  Icons.emoji_events,
                  color: const Color(0xFFFFB800),
                  size: 24.sp,
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}
