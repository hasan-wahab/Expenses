import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
class AddNewFloatingButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  bool isExtended;

  AddNewFloatingButton({super.key, this.isExtended = true, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      isExtended: isExtended,
      onPressed: onTap,
      label: SmallText(
        text: text,
        style: context.smallText!.copyWith(color: context.iconOnPrimary),
      ),
      icon: const Icon(Icons.add),
    );
  }
}
