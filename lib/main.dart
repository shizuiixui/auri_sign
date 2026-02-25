import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';

import 'features/homepage/presentation/screens/main_screen.dart'; 
import 'features/auth/presentation/screens/welcome page/welcome_page.dart';

import 'features/auth/viewmodels/user_view_model.dart';
import 'features/auth/presentation/viewmodels/login_view_model.dart';
import 'features/profile/viewmodels/achievements_view_model.dart';
import 'features/profile/viewmodels/profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dependency Injection
  await di.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<UserViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<AchievementsViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProfileViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<LoginViewModel>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AuriSign',
      home: FutureBuilder<bool>(
        future: context.read<LoginViewModel>().checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.data == true) {
            return const NavFunction();
          }
          return const WelcomePage();
        },
      ),
      routes: AppRouter.getRoutes(),
    );
  }
}