import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final int? maxLine;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? align;
  const SmallText({
    super.key,
    required this.text,
    this.style,
    this.align,
    this.maxLine,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow ?? TextOverflow.clip,
      maxLines: maxLine ?? 1,

      style: style ?? context.smallText,
      textAlign: align,
    );
  }
}
