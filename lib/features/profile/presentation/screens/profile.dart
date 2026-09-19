import 'package:auri_sign/features/profile/presentation/screens/achievements.dart';
import 'package:auri_sign/features/profile/presentation/screens/badges_page.dart';
import 'package:auri_sign/features/profile/presentation/widgets/delete_account_dialog.dart';
import 'package:auri_sign/features/profile/viewmodels/achievements_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Ensure plugin is available for the test

// Screens
import 'package:auri_sign/features/profile/presentation/screens/change_email.dart';
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
import '/core/widgets/role_badge.dart';
import 'package:auri_sign/features/profile/presentation/widgets/profile_helpers.dart';
import 'package:auri_sign/features/profile/presentation/widgets/logout_dialog.dart';

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

  // Logout Confirmation Dialog
  void _showLogoutConfirmation(BuildContext context, UserViewModel userVM) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => LogoutDialog(
        onConfirm: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB800)),
            ),
          );
          await Future.delayed(const Duration(milliseconds: 1800));
          await userVM.logout();
          if (context.mounted) {
            Navigator.of(context).pop();
            context.read<LoginViewModel>().clearSession();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomePage()),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  // Delete Account Confirmation Dialog
  void _showDeleteConfirmation(BuildContext context, UserViewModel userVM) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => DeleteAccountDialog(
        onConfirm: (password) async {
          Navigator.of(dialogContext).pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB800)),
            ),
          );

          try {
            await Future.delayed(const Duration(milliseconds: 1800));

            // Trigger backend call using captured password
            await userVM.deleteAccount(password);

            if (context.mounted) {
              Navigator.of(context).pop();

              context.read<LoginViewModel>().clearSession();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (route) => false,
              );
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          }
        },
      ),
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
    // Logic to get user initials
    String initial = "U";
    if (user?.firstName != null && user!.firstName.isNotEmpty) {
      final firstLetter = user.firstName[0].toUpperCase();
      final lastLetter = (user.lastName != null && user.lastName.isNotEmpty)
          ? user.lastName[0].toUpperCase()
          : '';
      initial = "$firstLetter$lastLetter";
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
                  fontSize: initial.length > 1 ? 38.sp : 45.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),

          // User Name and Email
          SizedBox(height: 12.h),
          Text(
            user != null && user.lastName != null && user.lastName.isNotEmpty
                ? "${user.firstName} ${user.lastName}"
                : (user?.firstName ?? "User"),
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? "",
            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
          ),

          SizedBox(height: 10.h),

          // Role Badge
          const RoleBadge(),

          SizedBox(height: 16.h),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [UserStatsRow()],
          ),

          SizedBox(height: 32.h),

          const CompletedLessonsCarousel(),
          SizedBox(height: 8.h),

          // Account Section
          const ProfileSectionHeader(title: "Account"),

          // Edit Profile
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

          // Change Email
          ProfileMenuTile(
            title: "Change Your Email",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeEmailPage(),
                ),
              );
            },
          ),

          // Change Password
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

          // Legal & Privacy Section
          const ProfileSectionHeader(title: "Legal & Privacy"),

          // Terms & Conditions
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

          // Privacy Policy
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

          // Achievements Section
          const ProfileSectionHeader(title: "Achievements"),

          // Download Certificates
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

          // Bagdes Showcase
          ProfileMenuTile(
            title: "Badges Showcase",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BadgesPage()),
              );
            },
          ),

          SizedBox(height: 40.h),
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
                minimumSize: Size(double.infinity, 45.h), //width & height
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
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          // Delete Account
          TextButton(
            onPressed: () {
              final userVM = context.read<UserViewModel>();
              _showDeleteConfirmation(context, userVM);
            },
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
