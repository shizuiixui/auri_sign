import 'package:flutter/material.dart';
import 'package:auri_sign/core/widgets/bottom_nav_bar.dart';
import 'package:auri_sign/features/profile/presentation/screens/profile.dart';
import 'package:auri_sign/features/homepage/presentation/screens/homepage.dart';

class NavFunction extends StatefulWidget {
  const NavFunction({super.key});

  @override
  State<NavFunction> createState() => _NavFunctionState();
}

class _NavFunctionState extends State<NavFunction> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    HomePage(
      onProfileTap: () {
        setState(() {
          _selectedIndex = 3; //Index 3
        });
      },
    ), // Index 0
    const SizedBox.shrink(), // Index 1
    const Center(child: Text("Dictionary Coming Soon")), // Index 2
    const ProfilePage(), // Index 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/gesture_detection');
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
