class Validators {
  Validators._();

  static String? validateName(String? value, {String fieldName = "Name"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required.";
    }

    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return "$fieldName must be at least 2 characters.";
    }
    if (trimmed.length > 50) {
      return "$fieldName must not exceed 50 characters.";
    }

    // Backend: /^[A-Za-z]+(?:\s[A-Za-z]+)*$/
    final nameExp = RegExp(r"^[A-Za-z]+(?:\s[A-Za-z]+)*$");
    if (!nameExp.hasMatch(trimmed)) {
      return "$fieldName must contain only letters.";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Email is required.";
    // Backend: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
    final emailRegex = RegExp(r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$");
    if (!emailRegex.hasMatch(value.trim())) {
      return "Invalid email format.";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.";
    }
    // Length (backend: min 8, max 128)
    if (value.length < 8) {
      return "Password must be at least 8 characters.";
    }
    if (value.length > 128) {
      return "Password must not exceed 128 characters.";
    }

    // Backend: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$/
    final bool hasLower = RegExp(r'[a-z]').hasMatch(value);
    final bool hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final bool hasNumber = RegExp(r'\d').hasMatch(value);
    final bool hasSpecial = RegExp(r'[^A-Za-z\d]').hasMatch(value);

    if (!hasLower || !hasUpper || !hasNumber || !hasSpecial) {
      return "Password must include uppercase, lowercase, number, and special character.";
    }
    return null;
  }

  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters.";
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
