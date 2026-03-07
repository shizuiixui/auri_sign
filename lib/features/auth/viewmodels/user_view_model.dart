import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_models.dart';
import '../data/repositories/user_repository.dart';
import 'package:auri_sign/config/api_constants.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  UserViewModel(this._userRepository);

  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String _errorMessage = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchUser(String token) async {
    _token = token;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          ApiConstants.userProfile,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _user = UserModel.fromJson(data);
      } else {
        _errorMessage = "Failed to load user";
      }
    } catch (e) {
      debugPrint("API Error: $e");
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        _user = null;
        _isLoading = false;
        notifyListeners();
        return;
      }
      _user = await _userRepository.getCurrentUser();

      print("SESSION RESTORED: Welcome back, ${_user?.firstName}");
    } catch (e) {
      print("SESSION EXPIRED: $e");
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      if (_token != null) {
        await http.post(
          Uri.parse(
            ApiConstants.logout,
          ), 
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        );
      }

      _user = null;
      _token = null;
    } catch (e) {
      debugPrint("Logout Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String newFirstName,
    required String newLastName,
    required String newEmail,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      if (_user != null &&
          (newFirstName != _user!.firstName ||
              newLastName != _user!.lastName)) {
        await _userRepository.updateName(newFirstName, newLastName);
      }
      if (_user != null && newEmail.isNotEmpty && newEmail != _user!.email) {
        await _userRepository.updateEmail(newEmail);
      }
      if (_user != null) {
        _user = _user!.copyWith(
          firstName: newFirstName,
          lastName: newLastName,
          email: newEmail,
        );
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _userRepository.updatePassword(currentPassword, newPassword);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
