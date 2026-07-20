import 'package:auri_sign/core/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // 1. Logo Section
              Padding(
                padding: EdgeInsets.only(top: 60.h), 
                child: Container(
                  width: 200.w,
                  height: 120.h,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/auri_sign_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h), 

              // 2. Text Section
              SizedBox(
                width: 328.w,
                child: Text(
                  'Your Smart AI Sign Language Learning Companion',
                  textAlign: TextAlign.start, 
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontFamily: 'Kantumruy Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: SizedBox(
                  width: 328.w,
                  child: Text(
                    'Empowering inclusive communication through AI-assisted learning.',
                    textAlign: TextAlign.start, 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: 'Kantumruy Pro',
                      fontWeight: FontWeight.w400,
                      height: 1.71,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // 3. Image Section
              Container(
                width: 328.w,
                height: 227.h,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF8F8F8),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 0.50),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  shadows: [
                    BoxShadow(
                      color: const Color(0x3F000000),
                      blurRadius: 4.r,
                      offset: Offset(0, 4.h),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 227.w,
                    height: 227.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/image1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(), 

              // 4. Buttons
              SizedBox(
                width: 328.w,
                child: Button(
                  text: "Get Started",
                  onPressed: () {
                    Navigator.pushNamed(context, '/profiling');
                  },
                ),
              ),
              
              SizedBox(height: 14.h),
              
              // Text Button
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  "I already have an account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.50.sp,
                    fontFamily: 'Kantumruy Pro',
                    fontWeight: FontWeight.w400,
                    height: 2.91,
                  ),
                ),
              ),

              SizedBox(height: 40.h), 
            ],
          ),
        ),
      ),
    );
  }
}