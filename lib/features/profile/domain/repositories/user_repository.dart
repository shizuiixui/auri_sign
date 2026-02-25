import 'dart:io';

abstract class UserRepository {
  Future<String> uploadProfilePicture(File imageFile);
}