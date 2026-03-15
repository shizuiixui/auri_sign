import 'package:dio/dio.dart';
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

  Future<CertificateData> getCertificateData(String categoryName) async {
    try {
      final token = await _getAuthToken();
      final encodedCategory = _toEncodedCategory(categoryName);

      final response = await _dio.get(
        '/certificates/$encodedCategory',
        options: _authOptions(token),
      );

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final certificateJson =
            (body['certificate'] as Map<String, dynamic>?) ??
            (body['data'] as Map<String, dynamic>?);
        if (certificateJson == null) {
          throw Exception('Invalid certificate response from server.');
        }
        return CertificateData.fromJson(certificateJson);
      }

      throw Exception('Failed to get certificate details. Please try again.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid category requested.');
      } else if (e.response?.statusCode == 404) {
        throw Exception(
          'Certificate not found. Please complete this category first.',
        );
      } else if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error while getting certificate details.');
      }
      throw Exception('Failed to fetch certificate details: ${e.message}');
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
      final token = await _getAuthToken();

      final encodedCategory = _toEncodedCategory(categoryName);

      // Get temporary directory to save PDF
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/certificate_${encodedCategory.replaceAll('%2F', '_')}.pdf';

      // Backend resolves user context from Authorization token.
      final response = await _dio.download(
        '/certificates/$encodedCategory/pdf',
        filePath,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
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
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid category requested.');
      } else if (e.response?.statusCode == 404) {
        throw Exception(
          'Certificate not found. Please complete all lessons in this category first.',
        );
      } else if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error while generating certificate PDF.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else {
        throw Exception('Failed to download certificate: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Verifies a certificate on the blockchain and returns typed verification data.
  Future<CertificateVerification> verifyCertificate(
    String categoryName,
    String userID,
  ) async {
    try {
      final token = await _getAuthToken();
      final apiCategoryName = _toApiCategoryName(categoryName);

      final response = await _dio.post(
        '/certificates/verify',
        data: {'userID': userID, 'category': apiCategoryName},
        options: _authOptions(token),
      );

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final verificationJson =
            (body['verification'] as Map<String, dynamic>?) ??
            (body['data'] as Map<String, dynamic>?) ??
            body;
        return CertificateVerification.fromJson(verificationJson);
      }

      throw Exception('Failed to verify certificate. Please try again.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Category not completed yet. Certificate not found.');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid category requested.');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error while verifying certificate.');
      }
      throw Exception('Failed to verify: ${e.message}');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
