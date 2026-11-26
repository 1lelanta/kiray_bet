abstract final class FormValidators {
  static String? name(String? value, {required String requiredMessage}) =>
      value == null || value.trim().isEmpty ? requiredMessage : null;

  static String? email(
    String? value, {
    required String requiredMessage,
    required String invalidMessage,
  }) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return requiredMessage;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : invalidMessage;
  }

  static String? password(
    String? value, {
    required String requiredMessage,
    required String shortMessage,
  }) {
    if (value == null || value.isEmpty) return requiredMessage;
    return value.length >= 6 ? null : shortMessage;
  }

  static String? phone(
    String? value, {
    required String requiredMessage,
    required String invalidMessage,
  }) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return requiredMessage;
    return RegExp(r'^(?:\+2519\d{8}|09\d{8})$').hasMatch(phone)
        ? null
        : invalidMessage;
  }
}
