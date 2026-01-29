import 'package:auri_sign/core/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String userName = "Kei"; // Temporary for testing only
  final String? profilePictureUrl = "https://i.pravatar.cc/150?img=5"; // Dummy image
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0XFFF8F8F8),
      
      body: SafeArea(
        top: true, 
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl!)
                        : null,
                    child: profilePictureUrl == null
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                  
                  const SizedBox(width: 12), // Spacing between image and text

                  // Text Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hi",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "$userName!", // (for testing) user name
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Notification
                  IconButton(
                    onPressed: () {}, 
                    icon: const Icon(Icons.notifications_outlined)
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Subtitle
              const Text(
                "Your Smart AI Sign Language\nLearning Companion",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 20),

              // Continue Lessons Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Continue Lessons",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      textBaseline: TextBaseline.alphabetic,
                    )
                  ),
                  const SizedBox(height: 9),
                  Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9B63B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
      // Bottom Nav Bar
      bottomNavigationBar: BottomNavBar(currentIndex: _selectedIndex, onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
    );
  }
}