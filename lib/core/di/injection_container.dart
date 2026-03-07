import 'package:get_it/get_it.dart';
import 'package:auri_sign/config/api_constants.dart';

// Auth Imports
import '../../features/auth/data/repositories/user_repository.dart';
import '../../features/auth/viewmodels/user_view_model.dart';
import '../../features/auth/presentation/viewmodels/login_view_model.dart';

// Profile Imports 
import '../../features/profile/viewmodels/achievements_view_model.dart';
import '../../features/profile/viewmodels/profile_view_model.dart';
import '../../features/profile/domain/usecases/upload_profile_picture_usecase.dart';

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
  
  // ViewModels
  sl.registerFactory(() => UserViewModel(sl()));
  sl.registerFactory(() => LoginViewModel());

  // Profile
  sl.registerFactory(() => AchievementsViewModel());
  sl.registerFactory(() => ProfileViewModel(uploadUseCase: sl()));

  // 3. Lessons & Categories 
  // Repository 
  sl.registerLazySingleton<LessonRepository>(
    () => LessonRepository(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  // Category ViewModel
  sl.registerFactory<CategoryViewModel>(
    () => CategoryViewModel(repository: sl()),
  );

  // Lesson ViewModel
  sl.registerFactory<LessonViewModel>(
    () => LessonViewModel(repository: sl()),
  );
}