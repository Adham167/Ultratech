class AppValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'برجاء إدخال الاسم بالكامل';
    }
    if (value.trim().length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'برجاء إدخال البريد الإلكتروني';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'برجاء إدخال رقم الهاتف';
    }
    // Simple Egyptian phone number validation (starts with 01)
    final phoneRegex = RegExp(r'^01[0125][0-9]{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'رقم الهاتف غير صالح (يجب أن يبدأ بـ 01 ويتكون من 11 رقم)';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'برجاء إدخال كلمة السر';
    }
    if (value.length < 6) {
      return 'كلمة السر يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  static String? validateRole(int? value) {
    if (value == null) {
      return 'برجاء اختيار الدور';
    }
    return null;
  }
}
