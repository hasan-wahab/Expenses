class ValidationUtils {
  ValidationUtils._();
  static String? usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "User is required";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  static String? confirmPasswordValidator(String? value, String cPassword) {
    if (value == null || value.trim().isEmpty) {
      return "Confirm password is required";
    }
    if (value != cPassword) {
      return "Password does not match";
    }
    return null;
  }
}
