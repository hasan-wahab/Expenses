import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';

class ExtraLargeText extends StatelessWidget {
  final String text;
  const ExtraLargeText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.extraLarge);
  }
}
