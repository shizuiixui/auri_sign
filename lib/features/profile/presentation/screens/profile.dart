import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Ensure plugin is available for the test

// Screens
import 'package:auri_sign/features/profile/presentation/screens/change_password_page.dart';
import 'package:auri_sign/features/profile/presentation/screens/edit_profile_page.dart';
import 'package:auri_sign/features/profile/presentation/screens/privacy_policy.dart';
import 'package:auri_sign/features/profile/presentation/screens/terms_conditions.dart';
import 'package:auri_sign/features/auth/presentation/screens/welcome page/welcome_page.dart';

// ViewModels
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import '/features/auth/presentation/viewmodels/login_view_model.dart';
import 'package:auri_sign/features/profile/viewmodels/notification_schedule_view_model.dart';

// Widgets
import '/core/widgets/user_stats.dart';
import 'package:auri_sign/features/profile/presentation/widgets/profile_helpers.dart';

// Use Cases
import 'package:auri_sign/features/profile/domain/usecases/set_schedule_enabled_usecase.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Handler for Daily Reminder Switch
  Future<void> _onScheduleChanged(
    BuildContext context,
    NotificationScheduleViewModel notificationVM,
    bool value,
  ) async {
    final result = await notificationVM.setScheduleEnabled(value);

    if (!context.mounted) return;

    if (result.status == SetScheduleStatus.permissionDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification permission is required.')),
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

  void _showLogoutConfirmation(
    BuildContext parentContext,
    UserViewModel viewModel,
  ) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
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
                    fontSize: 15.sp,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(height: 1.h, thickness: 1.h, color: Colors.grey.shade300),
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
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Divider(height: 1.h, thickness: 1.h, color: Colors.grey.shade300),
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
                      fontSize: 15.sp,
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
    // Logic to get the first letter
    String initial = "U";
    if (user?.firstName != null && user!.firstName!.isNotEmpty) {
      initial = user.firstName![0].toUpperCase();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),

          // Yellow Fill with White Text
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
            // Circle Avatar
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
            children: [UserStatsRow()],
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

          // Practice Reminder Switch
          ProfileSwitchTile(
            title: "Daily Practice Reminder",
            subtitle: "Remind me to practice daily",
            value: notificationVM.schedule != null,
            onChanged: (value) =>
                _onScheduleChanged(context, notificationVM, value),
            titleStyle: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            subtitleStyle: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
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

          /*
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
          */
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _showLogoutConfirmation(context, userVM),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: Size(double.infinity, 40.h), //width & height
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Log out",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Poppins-Regular',
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),
          
          TextButton(
            onPressed: () {},
            child: Text(
              "Delete Account",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
