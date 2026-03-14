import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/profile/viewmodels/badges_view_model.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';

class BadgesPage extends StatefulWidget {
  const BadgesPage({super.key});

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  // Badges List
  final List<Map<String, dynamic>> upcomingBadges = [
    {
      "days": 3,
      "name": "3-Day Streak",
      "desc": "Complete lessons for 3 consecutive days",
      "icon": Icons.local_fire_department,
      "color": Colors.grey.shade600,
    },
    {
      "days": 7,
      "name": "Week Warrior",
      "desc": "Complete lessons for 7 consecutive days",
      "icon": Icons.emoji_events,
      "color": Colors.green,
    },
    {
      "days": 14,
      "name": "Two Week Champion",
      "desc": "Complete lessons for 14 consecutive days",
      "icon": Icons.military_tech,
      "color": Colors.lightBlue,
    },
    {
      "days": 30,
      "name": "Month Master",
      "desc": "Complete lessons for 30 consecutive days",
      "icon": Icons.workspace_premium,
      "color": Colors.blue,
    },
    {
      "days": 50,
      "name": "50-Day Legend",
      "desc": "Complete lessons for 50 consecutive days",
      "icon": Icons.star,
      "color": const Color(0xFFFFB800),
    },
    {
      "days": 100,
      "name": "Centurion",
      "desc": "Complete lessons for 100 consecutive days",
      "icon": Icons.diamond,
      "color": Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userVM = context.read<UserViewModel>();
      final userId = userVM.user?.id;
      if (userId != null) {
        context.read<BadgesViewModel>().fetchUserProgress(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BadgesViewModel>();

    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0XFFF8F8F8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Your Badges",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: vm.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                children: [
                  // Top Stat Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          "Total Badges",
                          "${vm.totalBadges}",
                          Icons.military_tech,
                          const Color(0xFFFFB800),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildStatCard(
                          "Total Points",
                          vm.totalPoints.toStringAsFixed(0),
                          Icons.star,
                          const Color(0xFF1E74FD),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  //  Earned Badges Section
                  _buildEarnedBadgesCard(vm.earnedBadges),
                  SizedBox(height: 20.h),

                  //  Streak Badges to Earn List
                  _buildUpcomingBadgesCard(),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarnedBadgesCard(List<dynamic> earnedBadges) {
    return _buildCardWrapper(
      child: earnedBadges.isEmpty
          ? Column(
              children: [
                Icon(
                  Icons.military_tech,
                  size: 60.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 10.h),
                Text(
                  "No Badges Yet",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Complete lessons and maintain your streak to earn badges!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB800),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    "Start Learning",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Earned Badges",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 15.h),
                Wrap(
                  spacing: 15.w,
                  runSpacing: 15.h,
                  children: earnedBadges.map((badge) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundColor: const Color(0xFFE0F7FA),
                          child: Icon(
                            Icons.military_tech,
                            color: const Color(0xFF1E74FD),
                            size: 30.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          badge['name'] ?? "Badge",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }

  Widget _buildUpcomingBadgesCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Streak Badges to Earn",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 10.h),
          ...upcomingBadges.map((badge) {
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    badge['name'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  subtitle: Text(
                    badge['desc'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  trailing: Icon(
                    badge['icon'],
                    color: badge['color'],
                    size: 24.sp,
                  ),
                ),
                if (badge != upcomingBadges.last)
                  Divider(color: Colors.grey.shade200, height: 1),
              ],
            );
          }),
        ],
      ),
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
