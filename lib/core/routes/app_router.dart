import 'package:flutter/material.dart';
import 'package:auri_sign/config/api_constants.dart';

// Auth Screens
import '/features/auth/presentation/screens/login_form.dart';
import '/features/auth/presentation/screens/profiling/profiling.dart';
import '/features/auth/presentation/screens/email_verification.dart';
import '/features/auth/presentation/screens/signup.dart';
import '../../features/auth/presentation/screens/forgot_password.dart';

// Profile
import '/features/homepage/presentation/screens/main_screen.dart';
import '/features/profile/presentation/screens/profile.dart';

// Dictionary
import 'package:auri_sign/features/dictionary/data/repositories/dictionary_repository.dart';
import 'package:auri_sign/features/dictionary/presentation/viewmodels/dictionary_viewmodel.dart';
import 'package:auri_sign/features/dictionary/presentation/screens/dictionary.dart';

class AppRouter {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Welcome and Auth
      '/login': (context) => const LoginForm(),
      '/signup': (context) => const SignupForm(),
      '/verifyEmail': (context) => const VerifyEmail(email: ''),
      '/profiling': (context) => const ProfilingScreen(),
      '/forgot_password': (context) => const ForgotPasswordScreen(),

      // Homepage & Profile
      '/home': (context) => const NavFunction(),
      '/profile': (context) => const ProfilePage(),

      // Dictionary
      '/dictionary': (context) {
        final repository = DictionaryRepository(
          baseUrl: ApiConstants.dictionary,
          authToken: 'auth_token',
        );
        final viewModel = DictionaryViewModel(repository);

        return DictionaryPage(viewModel: viewModel);
      },
    };
  }
}
