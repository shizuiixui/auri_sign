import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy for AuriSign",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Effective Date: January 19, 2026",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              ),
              SizedBox(height: 24.h),
              Text(
                _getPrivacyText(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  String _getPrivacyText() {
    return '''AuriSign values your privacy and is committed to protecting your personal data. This Privacy Policy explains how information is collected, used, stored, and protected when you use the AuriSign web and mobile application.

1. Information We Collect
AuriSign may collect the following types of information:
• Personal Information: such as name, email address, and account credentials provided during registration
• Usage Data: including interactions with features, learning progress, and system activity
• Uploaded Content: such as images, feedback, or learning-related media voluntarily submitted by users
• Device and Technical Data: such as device type, browser, and basic system logs for performance and security purposes

2. How We Use Your Information
Collected information is used to:
• Create and manage user accounts
• Provide and improve learning features and AI-assisted services
• Track progress and personalize user experience
• Maintain system security and performance
• Support academic evaluation and system improvement

3. AI and Data Processing
Some features of AuriSign use artificial intelligence to assist learning and interaction. User-provided data may be processed by AI models solely for educational, analytical, and system improvement purposes. AI-generated outputs are not guaranteed to be fully accurate and should be used as learning support only.

4. Data Sharing and Disclosure
AuriSign does not sell or rent user data. Information may only be shared:
• With authorized system administrators for maintenance and academic purposes
• When required by law or institutional regulations
• In aggregated or anonymized form for system analysis and reporting

5. Data Storage and Security
Reasonable technical and organizational measures are implemented to protect user data from unauthorized access, loss, or misuse. While security is prioritized, no digital system can guarantee absolute protection.

6. User Rights and Choices
Users have the right to:
• Access and update their personal information
• Request deletion or deactivation of their account
• Withdraw consent for data usage where applicable

Requests may be subject to system or academic requirements.

7. Data Retention
User data is retained only for as long as necessary to fulfill educational, operational, or academic purposes, or as required by applicable laws and institutional policies.

8. Children’s Privacy
AuriSign is intended for educational use. Users under the age required by applicable law should only use the platform with appropriate guidance or permission from a guardian or institution.

9. Changes to This Privacy Policy
This Privacy Policy may be updated to reflect system changes or legal requirements. Continued use of AuriSign after updates indicates acceptance of the revised policy.

10. Contact Information
For questions, concerns, or requests related to privacy and data protection, please contact the AuriSign development team through the official platform channels.

By using AuriSign, you acknowledge that you have read and understood this Privacy Policy.''';
  }
}