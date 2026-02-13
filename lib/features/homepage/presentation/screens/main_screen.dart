import 'package:flutter/material.dart';
import 'package:auri_sign/core/widgets/bottom_nav_bar.dart';
import 'package:auri_sign/core/widgets/floating_action_button.dart';
import 'package:auri_sign/features/profile/presentation/screens/profile.dart';
import 'package:auri_sign/features/homepage/presentation/screens/homepage.dart'; 

class NavFunction extends StatefulWidget {
  const NavFunction({super.key});

  @override
  State<NavFunction> createState() => _NavFunctionState();
}

class _NavFunctionState extends State<NavFunction> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // Index 0
    const Center(child: Text("Dictionary Coming Soon")), // Index 1
    const ProfilePage(), // Index 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // Floating Action Button
      floatingActionButton: CustomFAB(
        onPressed: () => Navigator.pushNamed(context, '/gesture_detection'),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}