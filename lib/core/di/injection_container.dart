import 'package:get_it/get_it.dart';
import '/features/auth/viewmodels/user_view_model.dart';
import '/features/profile/viewmodels/achievements_view_model.dart';
import '/features/profile/viewmodels/profile_view_model.dart';
import '/features/auth/presentation/viewmodels/login_view_model.dart';
import '/features/profile/domain/usecases/upload_profile_picture_usecase.dart';
import '/features/profile/data/repositories/user_repository_impl.dart';
import '/features/profile/domain/repositories/user_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());

  // Use Cases
  sl.registerLazySingleton(() => UploadProfilePictureUseCase(repository: sl()));

  // ViewModels
  sl.registerFactory(() => UserViewModel());
  sl.registerFactory(() => AchievementsViewModel());
  sl.registerFactory(() => ProfileViewModel(uploadUseCase: sl()));
  sl.registerFactory(() => LoginViewModel());
}