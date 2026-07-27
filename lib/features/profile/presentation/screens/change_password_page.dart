import 'package:auri_sign/core/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:auri_sign/features/profile/presentation/widgets/change_password_helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureRetype = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Change Your Password",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      CustomPasswordField(
                        controller: _currentPasswordController,
                        hint: "Enter your current password",
                        isObscured: _obscureCurrent,
                        onVisibilityToggle: () {
                          setState(() {
                            _obscureCurrent = !_obscureCurrent;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomPasswordField(
                        controller: _newPasswordController,
                        hint: "Enter your new password",
                        isObscured: _obscureNew,
                        onVisibilityToggle: () {
                          setState(() {
                            _obscureNew = !_obscureNew;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomPasswordField(
                        controller: _retypePasswordController,
                        hint: "Re-type your password",
                        isObscured: _obscureRetype,
                        onVisibilityToggle: () {
                          setState(() {
                            _obscureRetype = !_obscureRetype;
                          });
                        },
                      ),
                      const Spacer(),
                      SizedBox(height: 40.h),
                      Button(
                        text: "Change Password",
                        isLoading: userVM.isLoading,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          final currentPw = _currentPasswordController.text;
                          final newPw = _newPasswordController.text;
                          final retypePw = _retypePasswordController.text;

                          if (currentPw.isEmpty ||
                              newPw.isEmpty ||
                              retypePw.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('All fields are required'),
                              ),
                            );
                            return;
                          }

                          if (newPw != retypePw) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('New passwords do not match!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          try {
                            await userVM.changePassword(
                              currentPassword: currentPw,
                              newPassword: newPw,
                            );

                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Password changed successfully!',
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
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
