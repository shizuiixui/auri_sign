import 'package:auri_sign/core/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GreetingsPage extends StatelessWidget {
  const GreetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final firstName = userVM.user?.firstName ?? 'User';
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/love.svg',
                width: 200.w,
                height: 200.h,
              ),
              SizedBox(height: 20.h),
              Text(
                "Hi, $firstName! Your Sign Language Journey Starts Here ",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                "Practice sign language with interactive lessons and AI-powered feedback. You're ready to begin.",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.h),

              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: Button(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFB800),
                        ),
                      ),
                    );

                    await Future.delayed(const Duration(milliseconds: 1800));

                    // THE FIX: Grab it from the disk where LoginViewModel saved it!
                    final prefs = await SharedPreferences.getInstance();
                    final String token = prefs.getString('auth_token') ?? '';

                    print(
                      "CHECKING DISK FOR TOKEN: $token",
                    ); // Let's verify it!

                    if (context.mounted) {
                      Navigator.of(context).pop(); // Close dialog

                      // Pass the token to your router
                      Navigator.pushReplacementNamed(
                        context,
                        '/greetings-fingerspelling',
                        arguments: token,
                      );
                    }
                  },
                  text: "Continue",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
