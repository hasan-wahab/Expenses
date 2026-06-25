import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  final String text;
  const LargeText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.primaryText);
  }
}
