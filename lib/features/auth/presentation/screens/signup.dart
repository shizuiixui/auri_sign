import 'package:auri_sign/features/auth/presentation/screens/email_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/widgets/button.dart';
import '/core/widgets/text_input_field.dart';
import '/core/utils/validators.dart';
import '/features/auth/presentation/viewmodels/signup_view_models.dart';

class SignupForm extends StatefulWidget {
  // 🎯 NEW: We opened the door to accept the profiling data from the previous screens!
  final int? motivation;
  final int? communicationContext;
  final int? dailyTime;

  const SignupForm({
    super.key,
    this.motivation,
    this.communicationContext,
    this.dailyTime,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  // Form Key
  final _signupFormKey = GlobalKey<FormState>();

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final signupVM = SignupViewModel();

  bool inputPassword = true;
  bool confirmInputPassword = true;
  bool _legalDisclaimer = false;

  @override
  void dispose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0XFFF8F8F8),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 48.h),
          child: Form(
            key: _signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      // Sign Up Title
                      Text(
                        "Sign Up and Start Learning",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.h),

                      // Sign Up Subtitle
                      Text(
                        "Create an account to save your daily goal and start your first lesson.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // First Name Text Field
                      TextFormField(
                        controller: firstNameController,
                        validator: (value) => Validators.validateName(
                          value,
                          fieldName: "First Name",
                        ),
                        keyboardType: TextInputType.name,
                        decoration: textInputField(
                          "Enter your first name",
                          prefixIcon: Icons.person,
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // Last Name Text Field
                      TextFormField(
                        controller: lastNameController,
                        validator: (value) => Validators.validateName(
                          value,
                          fieldName: "Last Name",
                        ),
                        keyboardType: TextInputType.name,
                        decoration: textInputField(
                          "Enter your last name",
                          prefixIcon: Icons.person,
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // Email Text Field
                      TextFormField(
                        controller: emailController,
                        validator: (value) => Validators.validateEmail(value),
                        keyboardType: TextInputType.emailAddress,
                        decoration: textInputField(
                          "name@example.com",
                          prefixIcon: Icons.email_outlined,
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // Password Field
                      TextFormField(
                        controller: passwordController,
                        validator: (value) =>
                            Validators.validatePassword(value),
                        obscureText: inputPassword,
                        decoration:
                            textInputField(
                              "Create a password",
                              prefixIcon: Icons.lock_outlined,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  inputPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                  size: 24.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    inputPassword = !inputPassword;
                                  });
                                },
                              ),
                            ),
                      ),
                      SizedBox(height: 14.h),

                      // Confirm Password Field
                      TextFormField(
                        controller: confirmPasswordController,
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                              value,
                              passwordController.text,
                            ),
                        obscureText: confirmInputPassword,
                        decoration:
                            textInputField(
                              "Re-type your password",
                              prefixIcon: Icons.lock_outlined,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  confirmInputPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                  size: 24.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    confirmInputPassword =
                                        !confirmInputPassword;
                                  });
                                },
                              ),
                            ),
                      ),
                      SizedBox(height: 8.h),

                      // Legal Disclaimer Checkbox
                      CheckboxListTile(
                        value: _legalDisclaimer,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _legalDisclaimer = value;
                          });
                        },
                        title: Text.rich(
                          TextSpan(
                            text: 'By signing up, you agree to our ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'and ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: const Color(0xFFE9B63B),
                      ),
                      SizedBox(height: 15.h),

                      // Sign Up Button
                      ListenableBuilder(
                        listenable: signupVM,
                        builder: (context, child) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: Button(
                              text: signupVM.isLoading
                                  ? "Loading..."
                                  : "Start Learning",
                              onPressed: () async {
                                if (signupVM.isLoading) return;

                                if (!_signupFormKey.currentState!.validate()) {
                                  return;
                                }

                                if (!_legalDisclaimer) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "You must agree to the Terms of Service.",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                await signupVM.signup(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  confirmPassword: confirmPasswordController
                                      .text
                                      .trim(),
                                  motivation: widget.motivation,
                                  communicationContext:
                                      widget.communicationContext,
                                  dailyTime: widget.dailyTime,
                                );

                                if (signupVM.errorMessage != null) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(signupVM.errorMessage!),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerifyEmail(
                                          email: emailController.text.trim(),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFE9B63B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
