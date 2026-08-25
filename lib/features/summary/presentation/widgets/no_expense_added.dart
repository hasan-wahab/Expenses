import 'package:expense_app/core/constant/const_text/add_expese_text.dart';
import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/wrapers.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NoExpenseAdded extends StatelessWidget {
  final SummaryArgs args;
  final VoidCallback? onExpenseAdded;

  const NoExpenseAdded({
    super.key,
    required this.args,
    this.onExpenseAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56.r,
              color: context.iconAccent,
            ),
            SizedBox(height: 20.h),
            SmallText(
              align: TextAlign.center,
              maxLine: 3,
              text: MonthlySummaryText.noExpenseAdded,
            ),
            if (args.canAddExpense) ...[
              SizedBox(height: 24.h),
              PrimaryButton(
                width: double.infinity,
                text: AddExpenseText.addExpenseText,
                onTap: () async {
                  final result = await context.push(
                    RoutesName.addExpenseScreen,
                    extra: AddExpenseArgs(
                      propertyCardId: args.propertyCardId.toString(),
                      propertyOwnerId: args.propertyOwnerId,
                      isSharedWithMe: args.isSharedWithMe,
                      propertyName: args.propertyName,
                    ),
                  );
                  if (result == true) {
                    onExpenseAdded?.call();
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
