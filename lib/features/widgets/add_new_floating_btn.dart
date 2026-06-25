import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/app_b_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNewFloatingButton extends StatelessWidget {
  final String text;
  bool isExtended;
  AddNewFloatingButton({super.key, this.isExtended = true, required this.text});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      foregroundColor: AppColors.white,
      isExtended: isExtended,
      onPressed: () {},
      label: SmallText(
        text: text,
        style: context.smallText!.copyWith(color: AppColors.white),
      ),
      icon: Icon(Icons.add),
    );
  }
}
