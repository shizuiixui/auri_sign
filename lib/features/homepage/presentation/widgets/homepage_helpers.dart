import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/widgets/user_stats.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/notifications/presentation/viewmodels/notification_center_view_model.dart';
import 'package:auri_sign/features/notifications/presentation/screens/notifications_page.dart';

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
    // Logic to get the first letter
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

            // Name Section
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

            // Notification Icon
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
                                unreadCount > 9 ? '9+' : unreadCount.toString(),
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

        // User Stats
        const UserStatsRow(trophyCount: 1, streakCount: 0),
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

  const CategorySectionCard({
    super.key,
    required this.title,
    required this.color,
    required this.imagePath,
    this.bigDisplayChar,
    this.bigDisplayIcon,
  });

  @override
  Widget build(BuildContext context) {
    bool hasBigElement = bigDisplayChar != null || bigDisplayIcon != null;

    return GestureDetector(
      onTap: () {
        if (title.contains("Alphabets")) {
          Navigator.pushNamed(context, '/category_alphabets');
        } else if (title.contains("Numbers")) {
          Navigator.pushNamed(context, '/category_numbers');
        } else if (title.contains("Common Words")) {
          Navigator.pushNamed(context, '/category_common_words');
        }
      },
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
