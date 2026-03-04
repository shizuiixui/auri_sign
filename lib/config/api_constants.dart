class ApiConstants {
  static const String ipAddress = "192.168.100.10"; // change with your laptop IP address
  static const String port = "5000";
  
  static const String baseUrl = "http://$ipAddress:$port/api";
  
  // Endpoints
  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";
  static const String lessons = "$baseUrl/lessons";
  static const String dictionary = "$baseUrl/dictionary";
  static const String userProfile = "$baseUrl/user/me";
  static const String logout = "$baseUrl/user/logout";
} 