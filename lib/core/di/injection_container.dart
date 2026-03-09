import 'package:get_it/get_it.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:auri_sign/config/api_constants.dart';

// Auth Imports
import '../../features/auth/data/repositories/user_repository.dart';
import '../../features/auth/viewmodels/user_view_model.dart';
import '../../features/auth/presentation/viewmodels/login_view_model.dart';

// Profile Imports
import '../../features/profile/viewmodels/achievements_view_model.dart';
import '../../features/profile/viewmodels/profile_view_model.dart';
import '../../features/profile/viewmodels/notification_schedule_view_model.dart';
import '../../features/profile/domain/usecases/upload_profile_picture_usecase.dart';
import '../../features/profile/domain/usecases/get_schedule_enabled_usecase.dart';
import '../../features/profile/domain/usecases/initialize_notifications_usecase.dart';
import '../../features/profile/domain/usecases/set_schedule_enabled_usecase.dart';
import '../../features/profile/domain/repositories/notification_schedule_repository.dart';
import '../../features/profile/data/repositories/notification_schedule_repository_impl.dart';
import '../../features/profile/data/datasources/local_notifications_data_source.dart';
import '../../features/profile/core/daily_reminder_config.dart';

// Lesson Imports
import '../../features/lessons/data/repositories/lesson_repository.dart';
import '../../features/lessons/presentation/viewmodels/lesson_view_model.dart';
import '../../features/lessons/presentation/viewmodels/category_view_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<UserRepository>(
    () => UserRepository(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  sl.registerLazySingleton(() => UploadProfilePictureUseCase(repository: sl()));

  // Notification scheduling dependencies
  sl.registerLazySingleton<LocalNotificationsDataSource>(
    () => LocalNotificationsDataSource(
      plugin: FlutterLocalNotificationsPlugin(),
    ),
  );

  sl.registerLazySingleton<NotificationScheduleRepository>(
    () => NotificationScheduleRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton(() => InitializeNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => GetScheduleEnabledUseCase(sl()));
  sl.registerLazySingleton(() => SetScheduleEnabledUseCase(sl()));

  // ViewModels
  sl.registerFactory(() => UserViewModel(sl()));
  sl.registerFactory(() => LoginViewModel());

  // Profile
  sl.registerFactory(() => AchievementsViewModel());
  sl.registerFactory(() => ProfileViewModel(uploadUseCase: sl()));
  sl.registerFactory(
    () => NotificationScheduleViewModel(
      initializeNotifications: sl(),
      getScheduleEnabled: sl(),
      setScheduleEnabled: sl(),
      schedule: DailyReminderConfig.schedule,
      timezoneName: DailyReminderConfig.timezoneName,
    ),
  );

  // Lessons & Categories
  sl.registerLazySingleton<LessonRepository>(
    () => LessonRepository(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  sl.registerFactory<CategoryViewModel>(
    () => CategoryViewModel(repository: sl()),
  );

  sl.registerFactory<LessonViewModel>(
    () => LessonViewModel(repository: sl()),
  );
}