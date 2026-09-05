import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auri_sign/config/api_constants.dart';
import 'package:auri_sign/models/certificate_models.dart';

class CertificateService {
  late Dio _dio;

  CertificateService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Authentication required. Please login first.');
    }

    return token;
  }

  Options _authOptions(String token) {
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  /// Maps category display names to API category names
  String _toApiCategoryName(String categoryDisplayName) {
    switch (categoryDisplayName.toLowerCase()) {
      case 'alphabets':
        return 'Alphabets';
      case 'numbers':
        return 'Numbers';
      case 'phrases':
      case 'phrases/words':
        return 'Phrases/Words';
      default:
        return categoryDisplayName;
    }
  }

  String _toEncodedCategory(String categoryDisplayName) {
    final apiCategoryName = _toApiCategoryName(categoryDisplayName);
    return Uri.encodeComponent(apiCategoryName);
  }

  /// Generates the certificate on the backend, then downloads and opens the PDF
  /// Downloads and opens a certificate PDF for the given category
  Future<void> downloadAndOpenCertificate(
    String categoryName,
    String userID,
  ) async {
    try {
      final token = await _getAuthToken();
      final encodedCategory = _toEncodedCategory(categoryName);

      debugPrint(
        '🚨 STEP 1: Sending DOWNLOAD request to /api/certificates/$encodedCategory/pdf',
      );

      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/certificate_${encodedCategory.replaceAll('%2F', '_')}.pdf';

      final response = await _dio.download(
        '/api/certificates/$encodedCategory/pdf',
        filePath,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      debugPrint('🚨 STEP 2 SUCCESS. File downloaded to: $filePath');

      if (response.statusCode == 200) {
        final result = await OpenFilex.open(filePath);

        if (result.type != ResultType.done) {
          throw Exception(
            'Could not open PDF. Install a PDF viewer app to view certificates.',
          );
        }
      } else {
        throw Exception('Failed to download certificate. Please try again.');
      }
    } on DioException catch (e) {
      debugPrint('🚨 DIO ERROR TRIGGERED!');
      debugPrint('🚨 ERROR PATH: ${e.requestOptions.path}');
      debugPrint('🚨 ERROR STATUS: ${e.response?.statusCode}');

      if (e.response?.statusCode == 400) {
        throw Exception('Invalid category requested.');
      } else if (e.response?.statusCode == 404) {
        throw Exception(
          'Not found. Please complete all lessons in this category first.',
        );
      } else if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error while generating certificate PDF.');
      } else {
        throw Exception('Failed to download certificate: ${e.message}');
      }
    } catch (e) {
      debugPrint('🚨 GENERAL ERROR: $e');
      throw Exception('Unexpected error while downloading certificate.');
    }
  }
}
