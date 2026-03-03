import 'package:get_it/get_it.dart';
import '../../features/auth/data/repositories/user_repository.dart';
import '../../features/auth/viewmodels/user_view_model.dart';
import '/features/profile/viewmodels/achievements_view_model.dart';
import '/features/profile/viewmodels/profile_view_model.dart';
import '/features/auth/presentation/viewmodels/login_view_model.dart';
import '/features/profile/domain/usecases/upload_profile_picture_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<UserRepository>(
    () => UserRepository(
      baseUrl: 'http://192.168.100.10:5000/api',
    ), // change with your laptop IP
  );
  sl.registerLazySingleton(() => UploadProfilePictureUseCase(repository: sl()));
  sl.registerFactory(() => UserViewModel(sl()));

  sl.registerFactory(() => AchievementsViewModel());
  sl.registerFactory(() => ProfileViewModel(uploadUseCase: sl()));
  sl.registerFactory(() => LoginViewModel());
}
