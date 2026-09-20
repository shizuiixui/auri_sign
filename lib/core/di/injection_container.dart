import 'package:get_it/get_it.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:auri_sign/config/api_constants.dart';
import '../../main.dart';

// Auth Imports
import '../../features/auth/data/repositories/user_repository.dart';
import '../../features/auth/viewmodels/user_view_model.dart';
import '../../features/auth/presentation/viewmodels/login_view_model.dart';

// Profile Imports
import '../../features/profile/viewmodels/achievements_view_model.dart';
import '../../features/profile/viewmodels/profile_view_model.dart';
import '../../features/profile/domain/usecases/upload_profile_picture_usecase.dart';

// Notification Imports
import '../../features/profile/data/datasources/local_notifications_data_source.dart';
import '../../features/profile/data/repositories/notification_schedule_repository_impl.dart';
import '../../features/profile/domain/repositories/notification_schedule_repository.dart';

// Lesson Imports
import '../../features/lessons/data/repositories/lesson_repository.dart';
import '../../features/lessons/presentation/viewmodels/category_view_model.dart';

// Use Cases
import 'package:auri_sign/features/profile/domain/usecases/set_schedule_enabled_usecase.dart';
import 'package:auri_sign/features/profile/domain/usecases/get_schedule_enabled_usecase.dart';

// View Models
import 'package:auri_sign/features/profile/viewmodels/notification_schedule_view_model.dart';
import '../../features/profile/viewmodels/sound_settings_view_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External Libraries
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => flutterLocalNotificationsPlugin,
  );
  // Data Sources
  // Notifications Data Source
  sl.registerLazySingleton<LocalNotificationsDataSource>(
    () => LocalNotificationsDataSource(plugin: sl()),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepository(baseUrl: ApiConstants.baseUrl),
  );
  sl.registerLazySingleton<LessonRepository>(
    () => LessonRepository(baseUrl: ApiConstants.baseUrl),
  );
  // Notification Repository
  sl.registerLazySingleton<NotificationScheduleRepository>(
    () => NotificationScheduleRepositoryImpl(dataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => UploadProfilePictureUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetScheduleEnabledUseCase(sl()));
  sl.registerLazySingleton(() => SetScheduleEnabledUseCase(sl()));

  // View Models

  // Auth
  sl.registerFactory(() => UserViewModel(sl()));
  sl.registerFactory(() => LoginViewModel());

  // Profile
  sl.registerFactory(() => AchievementsViewModel());
  sl.registerFactory(() => ProfileViewModel(uploadUseCase: sl()));

  // Lessons & Categories
  sl.registerFactory<CategoryViewModel>(
    () => CategoryViewModel(repository: sl()),
  );
  
  // Notifications
  sl.registerFactory(
    () => NotificationScheduleViewModel(
      getScheduleUseCase: sl(),
      setScheduleUseCase: sl(),
    ),
  );

  // Sound Settings
  sl.registerLazySingleton<SoundSettingsViewModel>(
    () => SoundSettingsViewModel(),
  );
}
