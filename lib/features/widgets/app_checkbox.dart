import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double? size;
  final bool? enabled;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size,
    this.enabled,
  });

  bool get _enabled => enabled ?? onChanged != null;

  @override
  Widget build(BuildContext context) {
    final boxSize = size ?? 22.r;
    final fill = !_enabled
        ? (value
              ? context.iconAccent.withValues(alpha: 0.45)
              : context.iconOnPrimary)
        : (value ? context.iconAccent : context.iconOnPrimary);
    final border = !_enabled
        ? context.iconAccent.withValues(alpha: 0.35)
        : context.iconAccent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _enabled ? () => onChanged!(!value) : null,
        borderRadius: BorderRadius.circular(6.r),
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: boxSize,
            width: boxSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: border, width: 1.6),
            ),
            child: value
                ? Icon(
                    Icons.check_rounded,
                    size: boxSize * 0.72,
                    color: context.iconOnPrimary,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
