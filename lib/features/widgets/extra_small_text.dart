import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class ExtraSmallText extends StatelessWidget {
  final String text;
  final TextAlign? align;
  const ExtraSmallText({super.key, required this.text,this.align});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: context.extraSmallText,textAlign: align,);
  }
}
