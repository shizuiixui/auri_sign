import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auri_sign/config/api_constants.dart';

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

  /// Downloads and opens a certificate PDF for the given category
  /// The userID is needed so backend can embed the correct TX Hash in the PDF
  /// Throws [Exception] if download fails or category is not completed
  Future<void> downloadAndOpenCertificate(
    String categoryName,
    String userID,
  ) async {
    try {
      // Get JWT token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Authentication required. Please login first.');
      }

      // Convert category name to API format
      final apiCategoryName = _toApiCategoryName(categoryName);

      // Get temporary directory to save PDF
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/certificate_${apiCategoryName.replaceAll('/', '_')}.pdf';

      // Make API call to download PDF with userID so backend embeds correct TX Hash
      final response = await _dio.download(
        '/certificates/$apiCategoryName/pdf?userID=$userID',
        filePath,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.bytes,
        ),
      );

      // Check if download was successful
      if (response.statusCode == 200) {
        // Open the PDF file
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
      if (e.response?.statusCode == 404) {
        throw Exception(
          'Certificate not found. Please complete all lessons in this category first.',
        );
      } else if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else {
        throw Exception(
          'Failed to download certificate: ${e.message}',
        );
      }
    } catch (e) {
      throw Exception(
        'Error: ${e.toString()}',
      );
    }
  }

  /// Verifies a certificate on the blockchain
  /// Returns verification details if successful
  /// This is a public endpoint - no authentication required
  Future<Map<String, dynamic>> verifyCertificate(
      String categoryName, String userID) async {
    try {
      // Convert category name to API format
      final apiCategoryName = _toApiCategoryName(categoryName);

      // Make API call to verify certificate (public endpoint, no auth needed)
      final response = await _dio.post(
        '/certificates/verify',
        data: {
          'userID': userID,
          'category': apiCategoryName,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to verify certificate. Please try again.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Certificate not found. Please download first.');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid request. Please try again.');
      } else {
        throw Exception('Failed to verify: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
