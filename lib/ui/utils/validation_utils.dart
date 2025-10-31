class ValidationUtils {
  static String? nonEmpty(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? positiveNumber(String? value, {String fieldName = 'Amount'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed <= 0) return 'Enter a valid $fieldName';
    return null;
  }

  static String? nonNull<T>(T? value, {String fieldName = 'Field'}) {
    if (value == null) return '$fieldName is required';
    return null;
  }
}
