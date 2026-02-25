import 'dart:io';

import '../../domain/repositories/user_repository.dart'; 

class UserRepositoryImpl implements UserRepository {
  @override
  Future<String> uploadProfilePicture(File imageFile) async {
    await Future.delayed(const Duration(seconds: 2)); 
    return "https://example.com/new_profile_image.jpg";
  }
}