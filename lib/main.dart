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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    await context.read<UserViewModel>().initSession();
    await context.read<LoginViewModel>().checkLoginStatus();
    final userViewModel = context.read<UserViewModel>();
    await userViewModel.initSession();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AuriSign',
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFFFB800)),
              ),
            )
          : (userVM.user != null ? const NavFunction() : const WelcomePage()),

      routes: AppRouter.getRoutes(),
    );
  }
}
