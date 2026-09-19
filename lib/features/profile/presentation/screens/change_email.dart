import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auri_sign/core/utils/validators.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSendingOtp = false;
  bool _isOtpSent = false;

  @override
  void dispose() {
    _newEmailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    FocusScope.of(context).unfocus();

    final newEmail = _newEmailController.text.trim();
    final userVM = context.read<UserViewModel>();
    final currentEmail = userVM.user?.email ?? '';

    final validationError = Validators.validateEmail(newEmail);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newEmail.toLowerCase() == currentEmail.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New email cannot be the same as your current email"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSendingOtp = true);

    try {
      debugPrint("change_email: Requesting OTP via updateEmailOnly for: $newEmail");
      // Calls PUT /api/user/update-email with { email: newEmail }
      final result = await userVM.updateEmailOnly(newEmail);
      if (!mounted) return;

      setState(() => _isOtpSent = true);
      final msg = result['message'] ?? "Verification code sent to $newEmail";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint("change_email: send OTP error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSendingOtp = false);
    }
  }

  Future<void> _handleVerifyAndSubmit() async {
    FocusScope.of(context).unfocus();

    final newEmail = _newEmailController.text.trim();
    final otp = _otpController.text.trim();
    final userVM = context.read<UserViewModel>();
    final currentEmail = userVM.user?.email ?? '';

    final validationError = Validators.validateEmail(newEmail);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newEmail.toLowerCase() == currentEmail.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New email cannot be the same as your current email"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (otp.isEmpty || otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the 6-digit verification code"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      debugPrint("change_email: Verifying & saving email via updateEmailOnly for: $newEmail");
      // Phase 2: calls PUT /api/user/update-email with { email: newEmail, otp: otp }
      final result = await userVM.updateEmailOnly(newEmail, otp: otp);
      if (!mounted) return;

      Navigator.pop(context);
      final msg = result['message'] ?? "Email updated successfully!";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint("change_email: verify & update error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final currentEmail = userVM.user?.email ?? 'No email set';

    final screenWidth = MediaQuery.sizeOf(context).width;
    final fieldIconSize = screenWidth < 600 ? 20.sp : 18.sp;

    return Scaffold(
      backgroundColor: const Color(0XFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0XFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Change Your Email",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "EMAIL CONFIGURATION",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF64748B),
                  letterSpacing: 0.6,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 12.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Email display box
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CURRENT EMAIL",
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF64748B),
                                letterSpacing: 0.8,
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              currentEmail,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // New Email Address Label
                      Text(
                        "New Email Address",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // New Email Address Input Field
                      TextFormField(
                        controller: _newEmailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !_isOtpSent,
                        style: TextStyle(fontSize: 14.sp, fontFamily: 'Inter'),
                        validator: Validators.validateEmail,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            size: fieldIconSize,
                            color: Colors.grey,
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 48.w,
                            minHeight: 48.h,
                          ),
                          suffixIcon: _isOtpSent
                              ? IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    size: 18.sp,
                                    color: const Color(0xFFFFB800),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isOtpSent = false;
                                      _otpController.clear();
                                    });
                                  },
                                )
                              : null,
                          hintText: 'Enter new email address',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                          ),
                          filled: true,
                          fillColor: _isOtpSent
                              ? const Color(0xFFF8FAFC)
                              : Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16.h,
                            horizontal: 16.w,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFB800),
                              width: 1.5,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                      ),

                      // Verification Code (OTP) only appears after Send Verification Code is clicked
                      if (_isOtpSent) ...[
                        SizedBox(height: 16.h),
                        Text(
                          "Verification Code (OTP)",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          style: TextStyle(
                            fontSize: 15.sp,
                            letterSpacing: 2.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              size: fieldIconSize,
                              color: Colors.grey,
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 48.w,
                              minHeight: 48.h,
                            ),
                            hintText: 'Enter 6-digit code',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14.sp,
                              letterSpacing: 0,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.normal,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 16.w,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: const BorderSide(
                                color: Color(0xFFFFB800),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Didn't receive code?",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF64748B),
                                fontFamily: 'Inter',
                              ),
                            ),
                            TextButton(
                              onPressed: _isSendingOtp ? null : _handleSendOtp,
                              child: _isSendingOtp
                                  ? SizedBox(
                                      width: 12.r,
                                      height: 12.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 1.8,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Color(0xFFFFB800),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "Resend Code",
                                      style: TextStyle(
                                        color: const Color(0xFFFFB800),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                      ] else ...[
                        SizedBox(height: 14.h),
                        Text(
                          "We'll send a verification code to your new email to confirm you own it.",
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            color: const Color(0xFF64748B),
                            height: 1.4,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],

                      // Action Button (Send Verification Code / Verify & Update Email)
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB800),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          onPressed: (_isLoading || _isSendingOtp)
                              ? null
                              : (_isOtpSent
                                  ? _handleVerifyAndSubmit
                                  : _handleSendOtp),
                          child: (_isLoading || _isSendingOtp)
                              ? SizedBox(
                                  width: 20.r,
                                  height: 20.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  _isOtpSent
                                      ? "Verify & Update Email"
                                      : "Send Verification Code",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Cancel Button
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF1E293B),
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            if (_isOtpSent) {
                              setState(() {
                                _isOtpSent = false;
                                _otpController.clear();
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
