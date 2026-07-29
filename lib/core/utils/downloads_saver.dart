import 'dart:typed_data';

import 'package:flutter/services.dart';

/// Saves files into the phone's public Downloads folder.
class DownloadsSaver {
  DownloadsSaver._();

  static const _channel = MethodChannel('com.hasan.expense_app/downloads');

  /// Returns saved path / content uri string.
  static Future<String> savePdf({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final result = await _channel.invokeMethod<String>(
      'saveToDownloads',
      <String, dynamic>{
        'fileName': fileName.endsWith('.pdf') ? fileName : '$fileName.pdf',
        'bytes': bytes,
      },
    );
    if (result == null || result.isEmpty) {
      throw Exception('Could not save PDF to Downloads');
    }
    return result;
  }
}
