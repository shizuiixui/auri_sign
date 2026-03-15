class CertificateData {
  final String userID;
  final String category;
  final DateTime? completedAt;
  final String? categoryBlockchainTxHash;

  const CertificateData({
    required this.userID,
    required this.category,
    required this.completedAt,
    required this.categoryBlockchainTxHash,
  });

  factory CertificateData.fromJson(Map<String, dynamic> json) {
    return CertificateData(
      userID: (json['userID'] ?? json['userId'] ?? json['user_id'] ?? '')
          .toString(),
      category: (json['category'] ?? '').toString(),
      completedAt: DateTime.tryParse((json['completedAt'] ?? '').toString()),
      categoryBlockchainTxHash:
          (json['categoryBlockchainTxHash'] ??
                  json['blockchainTxHash'] ??
                  json['txHash'] ??
                  json['tx_hash'])
              ?.toString(),
    );
  }
}

class CertificateVerification {
  final bool valid;
  final bool blockchainVerified;
  final String? blockchainTxHash;
  final String? message;

  const CertificateVerification({
    required this.valid,
    required this.blockchainVerified,
    required this.blockchainTxHash,
    required this.message,
  });

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    return false;
  }

  factory CertificateVerification.fromJson(Map<String, dynamic> json) {
    return CertificateVerification(
      valid: _toBool(json['valid']),
      blockchainVerified: _toBool(
        json['blockchainVerified'] ??
            json['isOnBlockchain'] ??
            json['verified'],
      ),
      blockchainTxHash:
          (json['blockchainTxHash'] ??
                  json['txHash'] ??
                  json['tx_hash'] ??
                  json['hash'])
              ?.toString(),
      message: (json['message'] ?? json['status'] ?? json['result'])
          ?.toString(),
    );
  }
}

class CertificateVerificationDetails {
  final CertificateData certificate;
  final CertificateVerification verification;

  const CertificateVerificationDetails({
    required this.certificate,
    required this.verification,
  });
}
