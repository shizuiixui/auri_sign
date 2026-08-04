import 'package:flutter/material.dart';
import '/core/widgets/loading_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth >= 600;
    final buttonWidth = isTablet ? 280.w : 328.w;
    final buttonHeight = isTablet ? 40.h : 50.h;
    final borderRadius = isTablet ? 24.r : 30.r;
    final fontSize = isTablet ? 15.sp : 16.5.sp;

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: ShapeDecoration(
          color: const Color(0xFFE9B63B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),

        // Button Text
        child: Center(
          child: isLoading
              ? SizedBox(height: 24.h, width: 24.w, child: LoadingIndicator())
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
