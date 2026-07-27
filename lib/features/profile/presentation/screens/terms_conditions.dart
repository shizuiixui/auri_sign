import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Terms and Conditions for AuriSign",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Effective Date: January 19, 2026",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Text(
                _getTermsText(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _getTermsText() {
    return '''Welcome to AuriSign, an AI-powered web and mobile platform designed to support sign language learning and improve communication accessibility. By accessing or using AuriSign, you agree to comply with and be bound by the following Terms and Conditions. If you do not agree, please discontinue use of the platform.

1. Acceptance of Terms
By creating an account, accessing, or using AuriSign, you acknowledge that you have read, understood, and agreed to these Terms and Conditions, as well as any applicable policies or guidelines provided by the platform.

2. Description of Service
AuriSign provides educational tools, AI-assisted features, and interactive resources related to sign language learning and communication. Features may include user accounts, learning modules, progress tracking, image or media uploads, and AI-supported assistance. Features may be updated, modified, or discontinued without prior notice.

3. User Accounts and Responsibilities
Users are responsible for maintaining the confidentiality of their account credentials and for all activities conducted under their account. You agree to provide accurate and complete information during registration and to update your information when necessary.

4. Acceptable Use
You agree to use AuriSign only for lawful, educational, and intended purposes. You must not:
• Upload or share harmful, offensive, misleading, or inappropriate content
• Attempt to disrupt, damage, or gain unauthorized access to the system
• Misuse AI features or exploit platform functionalities

Violation of these rules may result in account suspension or termination.

5. Content and Intellectual Property
All content, including but not limited to logos, designs, text, software, and AI-generated outputs, is owned by or licensed to AuriSign unless otherwise stated. Users retain ownership of content they submit but grant AuriSign a limited license to use such content for system functionality, improvement, and educational purposes.

6. Privacy and Data Protection
AuriSign respects user privacy. Personal data collected will be handled in accordance with applicable data protection laws and the platform’s Privacy Policy. By using the service, you consent to the collection and use of your data as described.

7. AI-Generated Content Disclaimer
AI-generated responses and learning assistance provided by AuriSign are intended for educational support only. Accuracy is not guaranteed, and users are encouraged to verify information independently.

8. Limitation of Liability
AuriSign shall not be held liable for any direct or indirect damages resulting from the use or inability to use the platform, including data loss, system interruptions, or reliance on AI-generated content.

9. Termination of Access
AuriSign reserves the right to suspend or terminate user access at any time for violations of these Terms or misuse of the platform, with or without prior notice.

10. Changes to Terms
These Terms and Conditions may be updated at any time. Continued use of AuriSign after changes are posted constitutes acceptance of the revised terms.

11. Governing Law
These Terms shall be governed by and interpreted in accordance with the laws applicable in the Philippines, unless otherwise required by law.

12. Contact Information
For questions or concerns regarding these Terms and Conditions, please contact the AuriSign development team through the official platform channels.

By using AuriSign, you acknowledge that you have read, understood, and agreed to these Terms and Conditions.''';
  }
}
