import 'dart:io';

import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ExpenseListCard extends StatelessWidget {
  final ExpenseEntity expense;
  final VoidCallback onTap;
  final bool isFirst;

  const ExpenseListCard({
    super.key,
    required this.expense,
    required this.onTap,
    this.isFirst = false,
  });

  bool get _hasReceipt =>
      expense.receiptImage != null && expense.receiptImage!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: isFirst ? 20.h : 0),
      color: AppColors.bgColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Receipt thumbnail
              GestureDetector(
                onTap: () {
                  if (!_hasReceipt) return;
                  context.push(
                    RoutesName.receiptFullScreen,
                    extra: expense.receiptImage,
                  );
                },
                child: Container(
                  height: 64.h,
                  width: 64.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.primary, width: 1.2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11.r),
                    child: _hasReceipt
                        ? Image.file(
                            File(expense.receiptImage!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _receiptPlaceholder();
                            },
                          )
                        : _receiptPlaceholder(),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SecondaryText(
                            text: expense.title.toString().toTitleCase(),
                            style: context.secondaryText!.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SmallText(
                          text: 'Rs : ${expense.amount}',
                          style: context.smallText!.copyWith(
                            color: AppColors.redColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    if ((expense.note ?? '').isNotEmpty)
                      SmallText(
                        maxLine: 2,
                        text: expense.note.toString().toSentenceCase(),
                      ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SecondaryText(
                          text: expense.date.toString(),
                          style: context.secondaryText!.copyWith(
                            color: AppColors.primary,
                            fontSize: 12.sp,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 14.r,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptPlaceholder() {
    return ColoredBox(
      color: AppColors.primary.withOpacity(0.08),
      child: Icon(
        Icons.receipt_long_outlined,
        color: AppColors.primary,
        size: 28.r,
      ),
    );
  }
}
