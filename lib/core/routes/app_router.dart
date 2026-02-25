import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Auth Screens
import '/features/auth/presentation/screens/login_form.dart';
import '/features/auth/presentation/screens/profiling/profiling.dart';
import '/features/auth/presentation/screens/email_verification.dart';
import '/features/auth/presentation/screens/signup.dart';
import '/features/auth/presentation/screens/welcome page/forgot_password.dart';
import '/features/auth/presentation/screens/welcome page/welcome_page.dart';

// Profile
import '/features/homepage/presentation/screens/main_screen.dart';
import '/features/profile/presentation/screens/profile.dart';

// Category
import '/features/category/presentation/screens/category_alphabet.dart';
import '/features/category/presentation/screens/category_common_words.dart';
import '/features/category/presentation/screens/category_numbers.dart';

// Gesture Detection
import '/features/gesture_detection/presentation/screens/gesture_detection_screen.dart';

// Lesson Screens
import '/features/lessons/presentation/screens/alphabets/alphabet_lesson1.dart';
import '/features/lessons/presentation/screens/alphabets/alphabet_lesson2.dart';
import '/features/lessons/presentation/screens/alphabets/alphabet_lesson3.dart';
import '/features/lessons/presentation/screens/alphabets/alphabet_lesson4.dart';
import '/features/lessons/presentation/screens/alphabets/alphabet_lesson5.dart';
import '/features/lessons/presentation/screens/alphabets/alphabet_lesson6.dart';
import '/features/lessons/presentation/screens/alphabets/alphabet_lesson7.dart';
import '/features/lessons/presentation/screens/numbers/numbers_lesson1.dart';
import '/features/lessons/presentation/screens/numbers/numbers_lesson2.dart';
import '/features/lessons/presentation/screens/numbers/numbers_lesson3.dart';

// Lesson ViewModels
import '/features/lessons/presentation/viewmodels/alphabets/alphabet_lesson1_view_model.dart';
import '/features/lessons/presentation/viewmodels/alphabets/alphabet_lesson2_view_model.dart';
import '/features/lessons/presentation/viewmodels/alphabets/alphabet_lesson3_view_model.dart';
import '/features/lessons/presentation/viewmodels/alphabets/alphabet_lesson4_view_model.dart';
import '/features/lessons/presentation/viewmodels/alphabets/alphabet_lesson5_view_model.dart';
import '/features/lessons/presentation/viewmodels/alphabets/alphabet_lesson6_view_model.dart';
import '/features/lessons/presentation/viewmodels/alphabets/alphabet_lesson7_view_model.dart';
import '/features/lessons/presentation/viewmodels/numbers/numbers_lesson1_view_model.dart';
import '/features/lessons/presentation/viewmodels/numbers/numbers_lesson2_view_model.dart';
import '/features/lessons/presentation/viewmodels/numbers/numbers_lesson3_view_model.dart';

class AppRouter {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Welcome and Auth
      '/': (context) => const WelcomePage(),
      '/login': (context) => const LoginForm(),
      '/signup': (context) => const SignupForm(),
      '/verifyEmail': (context) => const VerifyEmail(email: ''),
      '/profiling': (context) => const ProfilingScreen(),
      '/forgot_password': (context) => const ForgotPasswordScreen(),

      // Homepage & Profile
      '/home': (context) => const NavFunction(),
      '/profile': (context) => const ProfilePage(),

      // Gesture Detection
      '/gesture_detection': (context) => const GestureDetectionScreen(),

      // Categories
      '/category_alphabets': (context) => const CategoryAlphabetsPage(),
      '/category_numbers': (context) => const CategoryNumbersPage(),
      '/category_common_words': (context) => const CategoryCommonWordsPage(),

      // Alphabet Lessons
      '/alphabet_lesson1': (context) => ChangeNotifierProvider(
            create: (_) => AlphabetLesson1ViewModel(),
            child: const AlphabetLesson1Page(),
          ),
      '/alphabet_lesson2': (context) => ChangeNotifierProvider(
            create: (_) => AlphabetLesson2ViewModel(),
            child: const AlphabetLesson2Page(),
          ),
      '/alphabet_lesson3': (context) => ChangeNotifierProvider(
            create: (_) => AlphabetLesson3ViewModel(),
            child: const AlphabetLesson3Page(),
          ),
      '/alphabet_lesson4': (context) => ChangeNotifierProvider(
            create: (_) => AlphabetLesson4ViewModel(),
            child: const AlphabetLesson4Page(),
          ),
      '/alphabet_lesson5': (context) => ChangeNotifierProvider(
            create: (_) => AlphabetLesson5ViewModel(),
            child: const AlphabetLesson5Page(),
          ),
      '/alphabet_lesson6': (context) => ChangeNotifierProvider(
            create: (_) => AlphabetLesson6ViewModel(),
            child: const AlphabetLesson6Page(),
          ),
      '/alphabet_lesson7': (context) => ChangeNotifierProvider(
            create: (_) => AlphabetLesson7ViewModel(),
            child: const AlphabetLesson7Page(),
          ),

      // Number Lessons
      '/numbers_lesson1': (context) => ChangeNotifierProvider(
            create: (_) => NumbersLesson1ViewModel(),
            child: const NumbersLesson1Page(),
          ),
      '/numbers_lesson2': (context) => ChangeNotifierProvider(
            create: (_) => NumbersLesson2ViewModel(),
            child: const NumbersLesson2Page(),
          ),
      '/numbers_lesson3': (context) => ChangeNotifierProvider(
            create: (_) => NumbersLesson3ViewModel(),
            child: const NumbersLesson3Page(),
          ),
    };
  }
}