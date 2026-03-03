import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../domain/usecases/upload_profile_picture_usecase.dart';

class ProfileViewModel extends ChangeNotifier {
  final UploadProfilePictureUseCase uploadUseCase;
  ProfileViewModel({required this.uploadUseCase});

  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  Future<String?> pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );

      if (pickedFile == null) return null;

      _selectedImage = File(pickedFile.path);
      notifyListeners();

      _isUploading = true;
      notifyListeners();
      await uploadUseCase.call(_selectedImage!);

      _isUploading = false;
      notifyListeners();

      return "Profile picture updated successfully!";
    } catch (e) {
      _isUploading = false;
      notifyListeners();
      return "Failed to update image: $e";
    }
  }
}
