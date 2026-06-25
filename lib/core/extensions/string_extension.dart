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
