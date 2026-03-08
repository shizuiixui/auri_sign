import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/auth/presentation/viewmodels/login_view_model.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final loginVM = context.read<LoginViewModel>();
    final isLoggedIn = await loginVM.checkLoginStatus();

    if (!mounted) return;

    if (isLoggedIn) {
      await context.read<UserViewModel>().initSession();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/auri_sign_logo.png',
              width: 120, 
              height: 120,
            ),
            const SizedBox(height: 20),
            // Loading Spinner
            const CircularProgressIndicator(
              color: Color(0xFFFFB800),
            ),
          ],
        ),
      ),
    );
  }
}