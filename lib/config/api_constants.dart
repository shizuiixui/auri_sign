class ApiConstants {
  static const String ipAddress = "192.168.100.10"; // change with your laptop IP address
  static const String port = "5000";
  
  // Base URL
  static const String baseUrl = 'http://localhost:5000/api';
  
  // Authentication
  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";
  static const String logout = "$baseUrl/user/logout";

  // Dictionary
  static const String dictionary = "$baseUrl/dictionary";

  // Lessons
    static const String lessons = "$baseUrl/lessons";

  // Profile
  static const String userProfile = "$baseUrl/user/me";
  static const String profile = "$baseUrl/user/profile";
  static const String updateName = "$baseUrl/user/update-name";
  static const String updateEmail = "$baseUrl/user/update-email";
  static const String updatePassword = "$baseUrl/user/update-password";
  static const String uploadProfilePicture = "$baseUrl/user/upload-profile-picture";

  // AI Gesture WebView
  static const String gestureWebviewUrl = 'http://localhost:5173/ai_gesture';

  
} 