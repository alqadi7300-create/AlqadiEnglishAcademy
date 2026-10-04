class Validators {
  static String? required(String? value, String label) =>
      value == null || value.trim().isEmpty ? 'يرجى إدخال $label' : null;
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال البريد الإلكتروني';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
    return ok ? null : 'البريد الإلكتروني غير صحيح';
  }
}
