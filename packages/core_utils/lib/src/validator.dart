/// バリデーションユーティリティ
class Validator {
  /// メールアドレスの検証
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// 電話番号の検証（日本の形式）
  static bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^0\d{9,10}$');
    return phoneRegex.hasMatch(phone.replaceAll('-', ''));
  }

  /// 文字列が空でないか検証
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// 最小文字数の検証
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }
}
