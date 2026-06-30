import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SecondaryText extends StatelessWidget {
  final String text;
  final int? maxLine;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? align;
  const SecondaryText({
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
      overflow: overflow ?? TextOverflow.clip,
      maxLines: maxLine ?? 1,
      text,
      textAlign: align,
      style: style ?? context.secondaryText,
    );
  }
}
