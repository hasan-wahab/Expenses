import 'package:expense_app/core/constant/const_text/add_expese_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddExpenseCategory extends StatelessWidget {
  const AddExpenseCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: .infinity,
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: .start,
        children: [
          SmallText(text: AddExpenseText.category),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 78.h,
              mainAxisSpacing: 16.w,
              crossAxisSpacing: 16.h,
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              return Container(
                alignment: .center,
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  border: .all(color: AppColors.primary),
                  borderRadius: .circular(12.r),
                ),
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Icon(Icons.gas_meter),
                    SmallText(
                      text: AddExpenseText.gas,
                      style: context.smallText!.copyWith(fontWeight: .w500),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
