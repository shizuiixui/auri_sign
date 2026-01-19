import 'package:auri_sign/features/auth/presentation/screens/signup.dart';
import 'package:auri_sign/features/auth/presentation/screens/welcome%20page/welcome_page.dart';
import 'package:flutter/material.dart';
import 'features/auth/presentation/screens/login_form.dart';
import 'features/auth/presentation/screens/profiling/profiling.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AuriSign',

      // Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginForm(),
        '/signup': (context) => const SignupForm(),
        '/profiling': (context) => const ProfilingScreen(),
      },
    );
  }
}
