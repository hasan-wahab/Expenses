import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SecondaryText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const SecondaryText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(text,style:style?? context.secondaryText,);
  }
}
