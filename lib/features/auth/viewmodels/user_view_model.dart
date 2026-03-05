import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_client.dart';
import '../models/user_models.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUser(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${ApiClient.baseUrl}/user/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _user = UserModel.fromJson(data);
      }
    } catch (e) {
      debugPrint("API Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
