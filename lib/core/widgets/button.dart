import 'package:flutter/material.dart';
import '/core/widgets/loading_indicator.dart';

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
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: ShapeDecoration(
          color: const Color(0xFFE9B63B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
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
              ? const SizedBox(height: 24, width: 24, child: LoadingIndicator())
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15.5,
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
