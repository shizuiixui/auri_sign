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
