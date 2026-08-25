class AppCurrency {
  AppCurrency._();

  /// App uses Pakistani Rupee only
  static const String code = 'PKR';
  static const String symbol = 'PKR';

  static String format(num? amount) {
    final value = amount ?? 0;
    if (value == value.roundToDouble()) {
      return '$symbol ${value.toInt()}';
    }
    return '$symbol ${value.toStringAsFixed(2)}';
  }
}
