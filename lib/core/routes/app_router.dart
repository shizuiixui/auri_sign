import 'package:auri_sign/features/auth/presentation/screens/greetings/greetings-fingerspelling_page.dart';
import 'package:auri_sign/features/auth/presentation/screens/greetings/greetings_page.dart';
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
  // Shared bottom-nav tab state for returning to an existing tab without pushing.
  static final ValueNotifier<int> navTabIndex = ValueNotifier<int>(0);

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Welcome and Auth
      '/login': (context) => const LoginForm(),
      '/signup': (context) => const SignupForm(),
      '/verifyEmail': (context) => const VerifyEmail(email: ''),
      '/profiling': (context) => const ProfilingScreen(),
      '/forgot_password': (context) => const ForgotPasswordScreen(),
      '/greetings': (context) => const GreetingsPage(),
      '/greetings-fingerspelling': (context) {
        final token =
            ModalRoute.of(context)?.settings.arguments as String? ?? '';
        return GreetingFingerspellingPage(userToken: token);
      },

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
