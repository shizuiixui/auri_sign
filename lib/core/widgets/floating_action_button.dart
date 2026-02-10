import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
   final VoidCallback onPressed;

   const CustomFAB({
    Key? key,
    required this.onPressed,
   }): super(key: key);

   @override
   Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFFE9B63B),
      elevation: 8,
      child: Image.asset(
        'assets/images/FAB/scanner.png',
         width: 40,
         height: 40,
         color: Colors.white,
      )
      );
   }
}
