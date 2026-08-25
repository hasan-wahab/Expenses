/// 🔤 String Extensions
extension StringExtensions on String {
  /// Capitalize first letter
  String toCapitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Convert to Title Case
  String toTitleCase() {
    if (isEmpty) return this;

    return split(" ").map((word) => word.toCapitalize()).join(" ");
  }

  /// Convert to Sentence case
  String toSentenceCase() {
    if (isEmpty) return this;

    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

extension NullableStringExtensions on String? {
  /// Treat null / empty / "null" as empty for UI display
  String get orEmpty {
    if (this == null) return '';
    final value = this!.trim();
    if (value.isEmpty || value.toLowerCase() == 'null') return '';
    return value;
  }

  bool get hasValue => orEmpty.isNotEmpty;

  bool get isNetworkUrl {
    final value = orEmpty.toLowerCase();
    return value.startsWith('http://') || value.startsWith('https://');
  }

  /// First letter for avatar placeholder (username / email)
  String get initialLetter {
    final value = orEmpty;
    if (value.isEmpty) return '?';
    return value[0].toUpperCase();
  }
}
