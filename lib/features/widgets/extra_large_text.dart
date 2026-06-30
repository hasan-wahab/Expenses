import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';

class ExtraLargeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLine;
  final TextAlign? align;
  final TextOverflow? overflow;
  const ExtraLargeText({
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
      textAlign: align,
      text,
      style: style ?? context.extraLarge,
    );
  }
}
