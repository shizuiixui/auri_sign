import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'features/homepage/presentation/screens/main_screen.dart';
import 'features/auth/presentation/screens/welcome page/welcome_page.dart';
import 'features/auth/viewmodels/user_view_model.dart';
import 'features/auth/presentation/viewmodels/login_view_model.dart';
import 'features/profile/viewmodels/achievements_view_model.dart';
import 'features/profile/viewmodels/profile_view_model.dart';
import 'package:auri_sign/features/profile/viewmodels/notification_schedule_view_model.dart';
import 'package:auri_sign/features/notifications/presentation/viewmodels/notification_center_view_model.dart';
import '../../features/lessons/presentation/viewmodels/category_view_model.dart';
import 'package:auri_sign/features/profile/viewmodels/streak_view_model.dart';
import 'package:auri_sign/features/profile/viewmodels/badges_view_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Manila'));
  await di.init();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  [];
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {},
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<UserViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<AchievementsViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProfileViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<LoginViewModel>()),
        ChangeNotifierProvider(
          create: (_) => di.sl<NotificationScheduleViewModel>(),
        ),
        ChangeNotifierProvider(create: (_) => NotificationCenterViewModel()),
        ChangeNotifierProvider(create: (_) => di.sl<CategoryViewModel>()),
        ChangeNotifierProvider(create: (_) => StreakViewModel()),
        ChangeNotifierProvider(create: (_) => BadgesViewModel()),
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
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    await context.read<LoginViewModel>().checkLoginStatus();

    if (mounted) {
      await context.read<UserViewModel>().initSession();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AuriSign',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFF8F8F8),
          ),
          home: _isLoading
              ? Scaffold(
                  backgroundColor: const Color(0xFFF8F8F8),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/auri_sign_logo.png',
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 20),
                        const CircularProgressIndicator(
                          color: Color(0xFFFFB800),
                        ),
                      ],
                    ),
                  ),
                )
              : (userVM.user != null
                    ? const NavFunction()
                    : const WelcomePage()),
          routes: AppRouter.getRoutes(),
        );
      },
    );
  }
}
