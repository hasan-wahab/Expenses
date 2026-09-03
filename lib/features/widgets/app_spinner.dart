import 'package:flutter/material.dart';

/// Inline / page circular spinner (not a blocking dialog, not a skeleton).
/// Uses raw logical pixels so it can paint before ScreenUtilInit (app boot).
class AppSpinner extends StatelessWidget {
  const AppSpinner({super.key, this.size = 28, this.strokeWidth = 3});

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(strokeWidth: strokeWidth),
      ),
    );
  }

  /// Dim overlay spinner for a local widget (image pick, etc.).
  static Widget overlay({required bool show}) {
    if (!show) return const SizedBox.shrink();
    return const Positioned.fill(
      child: ColoredBox(
        color: Color(0x33000000),
        child: AppSpinner(),
      ),
    );
  }
}
