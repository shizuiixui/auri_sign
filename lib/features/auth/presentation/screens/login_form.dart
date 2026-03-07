import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/widgets/button.dart';
import '/core/widgets/text_input_field.dart';
import '/core/utils/validators.dart';
import '/features/auth/presentation/viewmodels/login_view_model.dart';
import '/features/auth/viewmodels/user_view_model.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  final loginVM = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0XFFF8F8F8),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 50.h),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome \nBack!",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Log in to continue learning sign language and building meaningful connections.",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                SizedBox(height: 20.h),
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
                TextFormField(
                  controller: passwordController,
                  validator: (value) => Validators.validatePassword(value),
                  obscureText: obscurePassword,
                  decoration: textInputField(
                    "Create a password",
                    prefixIcon: Icons.lock_outlined,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                        size: 24.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ListenableBuilder(
                  listenable: loginVM,
                  builder: (context, child) {
                    if (loginVM.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE9B63B),
                        ),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: Button(
                        text: "Get Started",
                        onPressed: () async {
                          if (_loginFormKey.currentState!.validate()) {
                            await loginVM.login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                            if (loginVM.errorMessage != null) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(loginVM.errorMessage!),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else if (loginVM.token != null) {
                              if (context.mounted) {
                                await context
                                    .read<UserViewModel>()
                                    .initSession();

                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                  );
                                }
                              }
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        "Sign Up",
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
        ),
      ),
    );
  }
}