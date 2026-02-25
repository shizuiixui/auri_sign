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
  await di.sl<LoginViewModel>().checkLoginStatus();

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {

    await context.read<LoginViewModel>().checkLoginStatus();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = context.watch<LoginViewModel>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AuriSign',
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFFFB800)),
              ),
            )
          : (loginVM.token != null ? const NavFunction() : const WelcomePage()),

      routes: AppRouter.getRoutes(),
    );
  }
}
