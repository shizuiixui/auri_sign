import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteAccountDialog extends StatefulWidget {
  final Function(String password) onConfirm;

  const DeleteAccountDialog({super.key, required this.onConfirm});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w), // Outer padding
      // We use a Column directly instead of a single Padding widget so
      // the horizontal Divider can bleed completely edge-to-edge
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- TOP SECTION (Text & Input) ---
          Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 28.h,
              bottom: 24.h,
            ),
            child: Column(
              children: [
                Text(
                  'Delete Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  'This action is permanent and cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFFE83E48), // Matching your logout red
                  ),
                ),
                SizedBox(height: 8.h),

                Text(
                  'All your learning streak, badges, and progress data will be permanently wiped.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.sp,
                    color: const Color(0XFF6C757D),
                  ),
                ),
                SizedBox(height: 24.h),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'Enter your current password',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      color: const Color(0XFFAAAAAA),
                    ),
                    errorText: _errorText,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Color(0XFFDFDFDF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Color(0XFFDFDFDF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Color(0xFFE9B63B), width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- EDGE-TO-EDGE DIVIDER ---
          const Divider(color: Color(0XFFEEEEEE), thickness: 1, height: 1),

          // --- BOTTOM SECTION (Buttons) ---
          Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 20.h,
              bottom: 24.h,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final password = _passwordController.text.trim();
                      if (password.isEmpty) {
                        setState(() => _errorText = 'Password is required');
                        return;
                      }
                      setState(() => _errorText = null);

                      // Pass the collected password back to your main screen
                      widget.onConfirm(password);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFFE83E48),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r), // Pill shape
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Yes, Delete My Account',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
