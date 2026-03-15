import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auri_sign/models/certificate_models.dart';

class CertificateVerifyDialog extends StatelessWidget {
  final String selectedCategory;
  final CertificateVerificationDetails details;

  const CertificateVerifyDialog({
    super.key,
    required this.selectedCategory,
    required this.details,
  });

  String _formatCompletedAt(DateTime? dateTime) {
    if (dateTime == null) return 'Not available';
    return DateFormat('MMM d, yyyy - h:mm a').format(dateTime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final txHash =
        details.verification.blockchainTxHash ??
        details.certificate.categoryBlockchainTxHash ??
        'Not available';

    final status = details.verification.blockchainVerified
        ? 'Verified on blockchain'
        : 'Not verified on blockchain';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: const Text(
        'Certificate Verification',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _InfoRow(label: 'Category', value: selectedCategory),
            const SizedBox(height: 10),
            _InfoRow(label: 'Status', value: status),
            const SizedBox(height: 10),
            _InfoRow(
              label: 'Completed at',
              value: _formatCompletedAt(details.certificate.completedAt),
            ),
            const SizedBox(height: 10),
            _InfoRow(label: 'Transaction Hash', value: txHash),
            if ((details.verification.message ?? '').isNotEmpty) ...[
              const SizedBox(height: 10),
              _InfoRow(label: 'Message', value: details.verification.message!),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
