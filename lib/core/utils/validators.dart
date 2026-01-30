class Validators {
  Validators._();

  static String? validateName(String? value, {String fieldName = "Name"}) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }

    if (value.length < 2) {
      return "$fieldName must be at least 2 characters long";
    }
    if (value.length > 20) {
      return "$fieldName cannot be more than 20 characters long";
    }

    final nameExp = RegExp(r"^[a-zA-Z\s\-\']+$");

    if (!nameExp.hasMatch(value)) {
      return "$fieldName can only contain letters, spaces, hyphens, and apostrophes";
    } else {
      return null;
    }
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    // Length
    if (value.length < 8) {
      return "Password must be at least 8 characters long!";
    }
    if (value.length > 20) {
      return "Password cannot be more than 20 characters long!";
    }
    // Space
    if (value.contains(' ')) {
      return "Password cannot contain spaces!";
    }
    // Complexity
    bool hasLower = RegExp(r'[a-z]').hasMatch(value);
    bool hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    bool hasNumber = RegExp(r'\d').hasMatch(value);

    if (!hasLower || !hasUpper || !hasNumber) {
      return "Password must contain at least one uppercase letter, one lowercase letter, and one number.";
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String? validatePassword,
  ) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password!";
    }
    if (value != validatePassword) {
      return "Passwords do not match!";
    }
    return null;
  }
}
