import 'dart:convert';
import 'dart:io'; // [1] Added for File
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_models.dart';

class UserRepository {
  final String baseUrl;

  UserRepository({required this.baseUrl});

  // Helper function
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Update Name
  Future<void> updateName(String firstName, String lastName) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/user/update-name'),
      headers: headers,
      body: jsonEncode({'firstName': firstName, 'lastName': lastName}),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Failed to update name');
    }
  }

  // Update Email
  Future<void> updateEmail(String email) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/user/update-email'),
      headers: headers,
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Failed to update email');
    }
  }

  // Update Password
  Future<void> updatePassword(String currentPassword, String newPassword) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/user/update-password'),
      headers: headers,
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Failed to update password');
    }
  }

  Future<UserModel> getCurrentUser() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/user/me'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to load user session');
    }
  }

  Future<String> uploadProfilePicture(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/user/upload-profile-picture'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'profilePicture',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['profilePictureUrl'];
    } else {
      throw Exception('Failed to upload image');
    }
  }
}