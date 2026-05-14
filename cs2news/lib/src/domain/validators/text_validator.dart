class TextValidator {
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  static bool isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
  }
}