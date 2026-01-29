import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Bottom Navigation Bar
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0XFFE9B63B),
      unselectedItemColor: const Color(0XFFBEBEBE),

      // Selected Label Style
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),

      // Unselected Label Style
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),

      items: [
        // Home
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottom_navbar/home.png',
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            'assets/images/bottom_navbar/home_selected.png',
            width: 24,
            height: 24,
          ),
          label: 'Home',
        ),

        // Dictionary
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottom_navbar/dictionary.png',
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            'assets/images/bottom_navbar/dictionary_selected.png',
            width: 24,
            height: 24,
          ),
          label: 'Dictionary',
        ),

        // Profile
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottom_navbar/profile.png',
            width: 24,
            height: 24,
          ),
           activeIcon: Image.asset(
            'assets/images/bottom_navbar/profile_selected.png',
            width: 24,
            height: 24,
          ),
          label: 'Profile'
        ),


      ],
    );
  }
}
