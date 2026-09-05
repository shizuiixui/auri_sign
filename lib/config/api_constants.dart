class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://aurisign-backend.onrender.com';
  // Authentication
  static const String login = "$baseUrl/api/auth/login";
  static const String register = "$baseUrl/api/auth/register";
  static const String logout = "$baseUrl/api/auth/logout";

  // Dictionary
  static const String dictionary = "$baseUrl/api/dictionary";

  // Lessons
  static const String lessons = "$baseUrl/api/lessons";

  // Profile
  static const String userProfile = "$baseUrl/api/user/me";
  static const String profile = "$baseUrl/api/user/profile";
  static const String updateName = "$baseUrl/api/user/update-name";
  static const String updateEmail = "$baseUrl/api/user/update-email";
  static const String updatePassword = "$baseUrl/api/user/update-password";
  static const String deleteAccount = "$baseUrl/api/user/delete-account";

  // AI Gesture WebView
  static const String webBaseUrl = 'https://auri-sign-web.vercel.app';

  static const String gestureWebviewUrl = '$webBaseUrl/ai_gesture/mobile';

  static String lessonWebviewUrl(String category, String lessonId) {
    return '$webBaseUrl/category/${category.toLowerCase()}/lesson/$lessonId';
  }

  static const String greetingFingerspellingWebviewUrl =
      '$webBaseUrl/greeting-fingerspelling';
}
