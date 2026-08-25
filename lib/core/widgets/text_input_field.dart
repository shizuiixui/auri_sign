import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


InputDecoration textInputField(
  String hintText, {

  IconData? prefixIcon,
  IconData? suffixIcon,
  Widget? suffixIconWidget,
}) {
  return InputDecoration(
    constraints: BoxConstraints(minHeight: 50.h, maxHeight: 50.h),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    isDense: true,
    hintText: hintText,
    hintStyle: TextStyle(fontSize: 14.sp, fontFamily: 'Inter',color: Color(0XFFB0B0B0)),

    prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, size: 14.sp, color: const Color(0XFFB0B0B0))
        : null,
    prefixIconConstraints: BoxConstraints(
      minWidth: 48,
      minHeight: 50.h,
      maxHeight: 50.h,
    ),

    suffixIcon:
        suffixIconWidget ??
        (suffixIcon != null
            ? Icon(suffixIcon, color: const Color(0XFFB0B0B0))
            : null),
    suffixIconConstraints: BoxConstraints(
      minWidth: 48,
      minHeight: 50.h,
      maxHeight: 50.h,
    ),

    // Border
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),

    // Enabled Border
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0XFFB0B0B0), width: 1),
      borderRadius: BorderRadius.circular(30),
    ),

    // Focused Border
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFE9B63B), width: 2),
      borderRadius: BorderRadius.circular(30),
    ),

    // Error Border
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0XFFDC3545), width: 1),
      borderRadius: BorderRadius.circular(30),
    ),

    // Focused Error Border
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0XFFDC3545), width: 2),
      borderRadius: BorderRadius.circular(30),
    ),
  );
}
