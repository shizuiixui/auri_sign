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
  bool _hasSeenFingerspelling = false;
  bool get hasSeenFingerspelling => _hasSeenFingerspelling;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchUser(String token) async {
    _token = token;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.userProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _user = UserModel.fromJson(data);
        if (_user?.id != null && _user!.id.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('current_user_id', _user!.id);
        }
      } else {
        _errorMessage = "Failed to load user";
        _user = null;
        _token = null;
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        await prefs.remove('current_user_id');
      }
    } catch (e) {
      debugPrint("API Error: $e");
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fingerspelling Completion Tracking
  Future<void> completeFingerspelling() async {
    final prefs = await SharedPreferences.getInstance();
    final String userId = _user?.id ?? '';
    await prefs.setBool('has_seen_fingerspelling_$userId', true);
    _hasSeenFingerspelling = true;
    notifyListeners();
  }

  // Session Management
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

      await fetchUser(token);

      final String userId = _user?.id ?? '';
      _hasSeenFingerspelling =
          prefs.getBool('has_seen_fingerspelling_$userId') ?? false;
    } catch (e) {
      debugPrint("Session Restore Error: $e");
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
      await prefs.remove('current_user_id');

      if (_token != null) {
        await http.post(
          Uri.parse(ApiConstants.logout),
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

  // Add the password parameter here
  Future<void> deleteAccount(String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      debugPrint(
        '🚨 DELETE REQUEST TO: ${ApiConstants.baseUrl}/api/user/delete-account',
      );

      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/api/user/delete-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ADD THE BODY HERE!
        body: jsonEncode({'password': password}),
      );

      debugPrint('🚨 STATUS CODE: ${response.statusCode}');
      debugPrint('🚨 RAW RESPONSE: ${response.body}');

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Failed to delete account.');
      }

      await prefs.remove('auth_token');

      debugPrint("SUCCESS: Account deleted successfully.");
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('Delete Account Error: $_errorMessage');
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String newFirstName,
    required String newLastName,
    String? newEmail,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      // Update Name via direct HTTP request
      if (_user != null &&
          (newFirstName != _user!.firstName ||
              newLastName != _user!.lastName)) {
        final response = await http.put(
          Uri.parse(ApiConstants.updateName),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'firstName': newFirstName,
            'lastName': newLastName,
          }),
        );

        if (response.statusCode != 200 && response.statusCode != 201) {
          final body = jsonDecode(response.body);
          throw Exception(
            body['message'] ?? 'Failed to update name on server.',
          );
        }
      }

      // Update Email via HTTP request
      if (_user != null &&
          newEmail != null &&
          newEmail.isNotEmpty &&
          newEmail != _user!.email) {
        final emailResponse = await http.put(
          Uri.parse(ApiConstants.updateEmail),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'email': newEmail}),
        );

        if (emailResponse.statusCode != 200) {
          final body = jsonDecode(emailResponse.body);
          throw Exception(body['message'] ?? 'Failed to update email.');
        }
      }

      if (_user != null) {
        _user = _user!.copyWith(
          firstName: newFirstName,
          lastName: newLastName,
          email: (newEmail != null && newEmail.isNotEmpty)
              ? newEmail
              : _user!.email,
        );
      }

      debugPrint("SUCCESS: Profile updated locally and on server.");
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint("Update Profile Error: $_errorMessage");
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> updateEmailOnly(String newEmail, {String? otp}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final Map<String, dynamic> bodyData = {'email': newEmail};
      if (otp != null && otp.isNotEmpty) {
        bodyData['otp'] = otp;
      }

      final emailResponse = await http.put(
        Uri.parse(ApiConstants.updateEmail),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(bodyData),
      );

      final body = jsonDecode(emailResponse.body);

      if (emailResponse.statusCode != 200 && emailResponse.statusCode != 201) {
        throw Exception(body['message'] ?? 'Failed to update email.');
      }

      // If OTP was provided and update succeeded, update local user
      if (otp != null && otp.isNotEmpty && _user != null) {
        _user = _user!.copyWith(email: newEmail);
        debugPrint("SUCCESS: Email updated locally and on server.");
      }

      return body is Map<String, dynamic> ? body : <String, dynamic>{};
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint("Update Email Error: $_errorMessage");
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
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.put(
        Uri.parse(ApiConstants.updatePassword),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final body = jsonDecode(response.body);
        throw Exception(
          body['message'] ?? 'Failed to update password on server.',
        );
      }

      debugPrint("SUCCESS: Password updated securely.");
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint("Change Password Error: $_errorMessage");
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
