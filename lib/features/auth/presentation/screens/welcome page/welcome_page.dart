import 'package:auri_sign/core/widgets/button.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LOGO SECTION
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // MAIN CONTENT SECTION
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Caption
                const SizedBox(
                  width: 328,
                  child: Text(
                    'Your Smart AI Sign Language Learning Companion',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Kantumruy Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: const SizedBox(
                    width: 328,
                    child: Text(
                      'Empowering inclusive communication through AI-assisted learning.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Kantumruy Pro',
                        fontWeight: FontWeight.w400,
                        height: 1.71,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Image inside Rectangle
                Container(
                  width: 328,
                  height: 227,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF8F8F8),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.50),
                      borderRadius: BorderRadius.circular(5),
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
                  child: Center(
                    child: Container(
                      width: 227,
                      height: 227,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/image1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                // Buttons
                Column(
                  children: [
                    SizedBox(
                      child: Button(
                        text: "Get Started",
                        onPressed: () {
                          Navigator.pushNamed(context, '/profiling');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "I already have an account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.50,
                          fontFamily: 'Kantumruy Pro',
                          fontWeight: FontWeight.w400,
                          height: 2.91,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
