import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class ExtraSmallText extends StatelessWidget {
  final String text;
  final TextAlign? align;
  final TextStyle? style;
  final int? maxLine;
  final TextOverflow? overflow;
  const ExtraSmallText({
    super.key,
    required this.text,
    this.align,
    this.style,
    this.maxLine,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLine ?? 1,
      overflow: overflow ?? TextOverflow.clip,
      text,
      style: style ?? context.extraSmallText,
      textAlign: align,
    );
  }
}
