import 'package:flutter/material.dart';

extension TextEditingControllerX on TextEditingController {
  void reset() {
    clear();
  }
}

extension TextEditingControllerListX on Iterable<TextEditingController> {
  void resetAll() {
    for (final controller in this) {
      controller.clear();
    }
  }

  void disposeAll() {
    for (final controller in this) {
      controller.dispose();
    }
  }
}
