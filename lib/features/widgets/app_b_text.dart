import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  const AppBarText({super.key, this.style, this.align, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? context.appBarTextStyle,
      textAlign: align,
    );
  }
}
