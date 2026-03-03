import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/dictionary_item.dart';

List<DictionaryItem> _parseDictionaryItems(String responseBody) {
  final List<dynamic> parsed = json.decode(responseBody);
  return parsed.map((json) => DictionaryItem.fromJson(json)).toList();
}

class DictionaryRepository {
  final String baseUrl;
  final String authToken;

  DictionaryRepository({required this.baseUrl, required this.authToken});

  Future<List<DictionaryItem>> fetchAllItems() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return await compute(_parseDictionaryItems, response.body);
    } else {
      print('==== FETCH ALL ITEMS FAILED ====');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load dictionary items');
    }
  }

  Future<DictionaryItem> fetchSignOfTheDay() async {
    final response = await http.get(
      Uri.parse('$baseUrl/sign-of-the-day'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return DictionaryItem.fromJson(json.decode(response.body));
    } else {
      print('==== SIGN OF THE DAY FAILED ====');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load Sign of the Day');
    }
  }
}
