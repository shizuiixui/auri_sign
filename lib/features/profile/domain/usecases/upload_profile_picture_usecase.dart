import 'dart:io';
import '../repositories/user_repository.dart';

class UploadProfilePictureUseCase {
  final UserRepository repository;

  UploadProfilePictureUseCase({required this.repository});

  Future<String> execute(File imageFile) async {
    try {
      return await repository.uploadProfilePicture(imageFile);
    } catch (e) {
      throw Exception('Failed to upload: $e');
    }
  }
}