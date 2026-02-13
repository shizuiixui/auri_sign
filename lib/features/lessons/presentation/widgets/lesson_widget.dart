import 'package:flutter/material.dart';

class LessonNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const LessonNavButton({
    super.key,
    required this.icon,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: onTap == null
              ? Colors.grey[200]
              : (backgroundColor ?? Colors.grey[300]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: onTap == null
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Icon(
          icon,
          color: onTap == null ? Colors.grey : (iconColor ?? Colors.black54),
        ),
      ),
    );
  }
}

class CameraCornerOverlay extends StatelessWidget {
  const CameraCornerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 40,
          left: 40,
          child: _Corner(isTop: true, isLeft: true),
        ),
        Positioned(
          top: 40,
          right: 40,
          child: _Corner(isTop: true, isLeft: false),
        ),
        Positioned(
          bottom: 40,
          left: 40,
          child: _Corner(isTop: false, isLeft: true),
        ),
        Positioned(
          bottom: 40,
          right: 40,
          child: _Corner(isTop: false, isLeft: false),
        ),
      ],
    );
  }
}

class _Corner extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _Corner({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Colors.grey, width: 4)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Colors.grey, width: 4)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Colors.grey, width: 4)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Colors.grey, width: 4)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: (isTop && isLeft) ? const Radius.circular(12) : Radius.zero,
          topRight: (isTop && !isLeft)
              ? const Radius.circular(12)
              : Radius.zero,
          bottomLeft: (!isTop && isLeft)
              ? const Radius.circular(12)
              : Radius.zero,
          bottomRight: (!isTop && !isLeft)
              ? const Radius.circular(12)
              : Radius.zero,
        ),
      ),
    );
  }
}
