class Validator {

  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
  /// Kiểm tra định dạng email
  static bool isValidEmail(String? value) {
    if (value == null || value.trim().isEmpty) return false;

    final emailRegex = RegExp(
        r"^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$"
    );

    return emailRegex.hasMatch(value.trim());
  }

  /// Kiểm tra username (chỉ chữ + số, 6-20 ký tự)
  static bool isValidUsername(String? value) {
    if (value == null || value.trim().isEmpty) return false;

    final usernameRegex = RegExp(r"^[a-zA-Z0-9]{6,20}$");

    return usernameRegex.hasMatch(value.trim());
  }

  /// Kiểm tra password hợp lệ (6-20 ký tự)
  static bool isValidPassword(String? value) {
    if (value == null || value.isEmpty) return false;

    return value.length >= 6 && value.length <= 20;
  }

  /// Kiểm tra password và confirm password có trùng nhau hay không
  static bool isPasswordMatch(String? password, String? confirm) {
    if (password == null || confirm == null) return false;

    return password == confirm;
  }
}
