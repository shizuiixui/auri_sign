import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

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
import 'package:auri_sign/features/profile/viewmodels/profile_view_model.dart';
import '/features/auth/presentation/viewmodels/login_view_model.dart';

// Widgets
import '/core/widgets/user_stats.dart';
import 'package:auri_sign/features/profile/presentation/widgets/profile_helpers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _handleImageSelection(
    BuildContext context,
    ProfileViewModel profileVM,
    ImageSource source,
  ) async {
    Navigator.pop(context);

    final resultMessage = await profileVM.pickAndUploadImage(source);

    if (resultMessage != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(resultMessage)));
    }
  }

  void _showImagePickerBottomSheet(
    BuildContext context,
    ProfileViewModel profileVM,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Change Profile Picture",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () => _handleImageSelection(
                  context,
                  profileVM,
                  ImageSource.gallery,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () => _handleImageSelection(
                  context,
                  profileVM,
                  ImageSource.camera,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation(
    BuildContext parentContext,
    UserViewModel viewModel,
  ) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Logout", textAlign: TextAlign.center),
          content: const Text(
            "Are you sure you want to log out of your account?",
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final profileVM = context.watch<ProfileViewModel>();
    final user = userVM.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: userVM.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildProfileContent(context, user, userVM, profileVM),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    dynamic user,
    UserViewModel userVM,
    ProfileViewModel profileVM,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          GestureDetector(
            onTap: () => _showImagePickerBottomSheet(context, profileVM),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: profileVM.selectedImage != null
                      ? FileImage(profileVM.selectedImage!) as ImageProvider
                      : (user?.profilePicture != null
                            ? NetworkImage(user!.profilePicture!)
                            : null),
                  child:
                      (profileVM.selectedImage == null &&
                          user?.profilePicture == null)
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : (profileVM.isUploading
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : null),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Text(
            user?.firstName ?? "User",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? "",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),

          const SizedBox(height: 16),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [UserStatsRow(trophyCount: 1, streakCount: 0)],
          ),

          const SizedBox(height: 32),

          const CompletedLessonsCarousel(),
          const SizedBox(height: 8),

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

          const SizedBox(height: 20),

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

          const SizedBox(height: 20),

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

          const SizedBox(height: 40),

          OutlinedButton(
            onPressed: () => _showLogoutConfirmation(context, userVM),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Colors.redAccent, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              "Log out",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          TextButton(
            onPressed: () {},
            child: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
