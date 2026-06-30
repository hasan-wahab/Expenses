import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  final String text;
  final int? maxLine;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? align;
  const LargeText({
    super.key,
    required this.text,
    this.style,
    this.maxLine,
    this.overflow,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLine ?? 1,
      overflow: overflow ?? TextOverflow.clip,
      textAlign: align,
      text,
      style: style ?? context.primaryText,
    );
  }
}
