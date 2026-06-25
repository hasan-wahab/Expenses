import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  const SmallText({super.key, required this.text, this.style,this.align});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style ?? context.smallText,textAlign: align,);
  }
}
