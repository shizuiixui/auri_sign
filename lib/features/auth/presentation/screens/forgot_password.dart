import 'package:auri_sign/features/auth/presentation/viewmodels/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/widgets/text_input_field.dart';
import '/core/utils/validators.dart';
import '/core/widgets/button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final PageController _controller = PageController();

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;
    final viewModel = context.read<ForgotPasswordViewModel>();
    final success = await viewModel.requestReset(emailController.text.trim());

    if (success && mounted) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? "Failed to send reset link."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: 'KantumruyPro-Regular',
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Page 1: Email Form
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        "Enter your email address and we'll send you a link to reset your password.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'KantumruyPro-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      TextFormField(
                        style: TextStyle(fontSize: 14.sp, fontFamily: 'Inter'),
                        controller: emailController,
                        validator: (value) => Validators.validateEmail(value),
                        keyboardType: TextInputType.emailAddress,
                        decoration: textInputField(
                          "Enter your email",
                          prefixIcon: Icons.email_outlined,
                        ),
                      ),
                      SizedBox(height: 60.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: Button(
                          text: _isLoading ? "Sending..." : "Send Reset Link",
                          onPressed: () {
                            if (_isLoading) return;
                            _sendResetLink();
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),

            // Page 2: Success Message
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    Icon(
                      Icons.mark_email_read_outlined,
                      size: 100.w,
                      color: const Color(0xFFFFB800),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Check Your Email",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      "We have sent a password reset link to your email. Please click the link in the email to change your password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'KantumruyPro-Regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: Button(
                        text: "Back to Login",
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
