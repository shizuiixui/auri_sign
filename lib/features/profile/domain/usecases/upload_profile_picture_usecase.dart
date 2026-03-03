import '../../../auth/data/repositories/user_repository.dart'; 

class UploadProfilePictureUseCase {
  final UserRepository repository;

  UploadProfilePictureUseCase({required this.repository});
  Future<String> call(dynamic file) async {
    return await repository.uploadProfilePicture(file);
  }
}