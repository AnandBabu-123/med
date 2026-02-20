class Validations {
  /// 📧 Email Validation
  static bool validateEmail(String email) {
    final emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email); // returns true/false only
  }

  static bool validatePassword(String password) {
    return password.length >= 6;
  }

}
