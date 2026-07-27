import 'package:auri_sign/core/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:auri_sign/features/profile/presentation/widgets/edit_profile_helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final userVM = Provider.of<UserViewModel>(context, listen: false);
    final user = userVM.user;

    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final user = userVM.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit Your Profile",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: user?.profilePicture != null
                    ? NetworkImage(user!.profilePicture!)
                    : null,
                child: user?.profilePicture == null
                    ? Icon(Icons.person, size: 50.r, color: Colors.grey)
                    : null,
              ),
              SizedBox(height: 40.h),
              EditProfileTextField(
                controller: _firstNameController,
                hint: 'First Name',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16.h),
              EditProfileTextField(
                controller: _lastNameController,
                hint: 'Last Name',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16.h),
              EditProfileTextField(
                controller: _emailController,
                hint: 'Email Address',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 50.h),
              Button(
                text: "Continue",
                isLoading: userVM.isLoading,
                onPressed: () async {
                  FocusScope.of(context).unfocus();

                  final newFirstName = _firstNameController.text.trim();
                  final newLastName = _lastNameController.text.trim();
                  final newEmail = _emailController.text.trim();

                  if (newFirstName.isEmpty ||
                      newLastName.isEmpty ||
                      newEmail.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All fields are required'),
                      ),
                    );
                    return;
                  }

                  try {
                    await userVM.updateProfile(
                      newFirstName: newFirstName,
                      newLastName: newLastName,
                      newEmail: newEmail,
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Profile updated successfully!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}