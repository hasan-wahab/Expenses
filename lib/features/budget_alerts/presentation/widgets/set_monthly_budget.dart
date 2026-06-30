import 'package:expense_app/core/constant/const_text/alart_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetMonthlyBudget extends StatelessWidget {
  const SetMonthlyBudget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16.r),
      decoration: BoxDecoration(
        border: .all(color: AppColors.primary),
        borderRadius: .circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 16.h,
        children: [
          SecondaryText(text: AlertScreenText.setMonthlyBudget),
          AppTField(
            hintText: AlertScreenText.enterAmount,
            labelText: AlertScreenText.enterAmount,
          ),
          PrimaryButton(text: AlertScreenText.saveText, onTap: () {}),
        ],
      ),
    );
  }
}
