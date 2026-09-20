import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isObscured;
  final VoidCallback onVisibilityToggle;
  final double? borderRadius;

  const CustomPasswordField({
    super.key,
    required this.controller,
    required this.hint,
    required this.isObscured,
    required this.onVisibilityToggle,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final iconSize = screenWidth < 600 ? 20.sp : 18.sp;

    return TextField(
      controller: controller,
      obscureText: isObscured,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Inter',
        color: const Color(0xFF1E293B),
      ),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 18.w, right: 12.w),
          child: Icon(
            Icons.lock,
            size: iconSize,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: IconButton(
            icon: Icon(
              isObscured
                  ? Icons.visibility_off
                  : Icons.visibility,
              size: iconSize,
            ),
            onPressed: onVisibilityToggle,
            splashRadius: 20.r,
          ),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14.sp,
          fontFamily: 'Inter',
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
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
          borderSide: const BorderSide(color: Color(0xFFFFB800), width: 1.5),
        ),
      ),
    );
  }
}
