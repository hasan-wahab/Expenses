import 'dart:io';

import 'package:expense_app/core/extensions/string_extension.dart';

/// Prefer: network URL → existing local file → Auth/Google photo URL
String resolveProfileImageUrl({
  String? storedImageUrl,
  String? networkFallbackUrl,
}) {
  final stored = storedImageUrl.orEmpty;
  if (stored.isNetworkUrl) return stored;
  if (stored.isNotEmpty && File(stored).existsSync()) return stored;
  return networkFallbackUrl.orEmpty;
}
