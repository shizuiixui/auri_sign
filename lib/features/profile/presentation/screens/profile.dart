import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Screens
import 'package:auri_sign/features/profile/presentation/screens/achievements.dart';
import 'package:auri_sign/features/profile/presentation/screens/change_password_page.dart';
import 'package:auri_sign/features/profile/presentation/screens/edit_profile_page.dart';
import 'package:auri_sign/features/profile/presentation/screens/privacy_policy.dart';
import 'package:auri_sign/features/profile/presentation/screens/terms_conditions.dart';
import 'package:auri_sign/features/auth/presentation/screens/welcome page/welcome_page.dart';

// ViewModels
import 'package:auri_sign/features/profile/viewmodels/achievements_view_model.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:auri_sign/features/profile/viewmodels/notification_schedule_view_model.dart';
import 'package:auri_sign/features/profile/domain/usecases/set_schedule_enabled_usecase.dart';
import '/features/auth/presentation/viewmodels/login_view_model.dart';

// Widgets
import '/core/widgets/user_stats.dart';
import 'package:auri_sign/features/profile/presentation/widgets/profile_helpers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showLogoutConfirmation(
    BuildContext parentContext,
    UserViewModel viewModel,
  ) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(24.0.w),
                child: Text(
                  "Are you sure you want to log out of your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                height: 1.h,
                thickness: 1.h,
                color: Colors.grey.shade300,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    await viewModel.logout();
                    if (parentContext.mounted) {
                      parentContext.read<LoginViewModel>().clearSession();
                      Navigator.pushAndRemoveUntil(
                        parentContext,
                        MaterialPageRoute(
                          builder: (context) => const WelcomePage(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1.h,
                thickness: 1.h,
                color: Colors.grey.shade300,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20.r),
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onScheduleChanged(
    BuildContext context,
    NotificationScheduleViewModel notificationVM,
    bool value,
  ) async {
    final result = await notificationVM.setScheduleEnabled(value);
    if (!context.mounted) {
      return;
    }

    if (result.status == SetScheduleStatus.permissionDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification permission is required.'),
        ),
      );
      return;
    }

    if (result.status == SetScheduleStatus.enabledInexact) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Exact alarm permission not granted. Notification may be delayed.',
          ),
        ),
      );
      return;
    }

    if (result.status == SetScheduleStatus.failed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update schedule: ${result.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final notificationVM = context.watch<NotificationScheduleViewModel>();
    final user = userVM.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: userVM.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildProfileContent(context, user, userVM, notificationVM),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    dynamic user,
    UserViewModel userVM,
    NotificationScheduleViewModel notificationVM,
  ) {
    String initial = "U";
    if (user?.firstName != null && user!.firstName!.isNotEmpty) {
      initial = user.firstName![0].toUpperCase();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB800).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50.r,
              backgroundColor: const Color(0xFFFFB800),
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 45.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),

          SizedBox(height: 12.h),
          Text(
            user?.firstName ?? "User",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? "",
            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
          ),

          SizedBox(height: 16.h),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [UserStatsRow(trophyCount: 1, streakCount: 0)],
          ),

          SizedBox(height: 32.h),

          const CompletedLessonsCarousel(),
          SizedBox(height: 8.h),

          const ProfileSectionHeader(title: "Account"),

          ProfileMenuTile(
            title: "Edit Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
          ProfileMenuTile(
            title: "Change Your Password",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordPage(),
                ),
              );
            },
          ),

          SizedBox(height: 20.h),

          const ProfileSectionHeader(title: "Notifications"),

          ProfileSwitchTile(
            title: "Daily Reminder",
            subtitle: "Turn on/off daily reminder notification",
            value: notificationVM.isScheduleEnabled,
            onChanged: notificationVM.isUpdatingSchedule
                ? null
                : (value) {
                    _onScheduleChanged(context, notificationVM, value);
                  },
          ),

          SizedBox(height: 20.h),

          const ProfileSectionHeader(title: "Legal & Privacy"),

          ProfileMenuTile(
            title: "Terms & Conditions",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsConditionsPage(),
                ),
              );
            },
          ),
          ProfileMenuTile(
            title: "Privacy Policy",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage(),
                ),
              );
            },
          ),

          SizedBox(height: 20.h),

          const ProfileSectionHeader(title: "Achievements"),

          ProfileMenuTile(
            title: "Download Certificates",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => AchievementsViewModel(),
                    child: const AchievementsPage(),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 40.h),

          ElevatedButton(
            onPressed: () => _showLogoutConfirmation(context, userVM),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: Size(double.infinity, 50.h),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              "Log out",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),

          TextButton(
            onPressed: () {},
            child: Text(
              "Delete Account",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}