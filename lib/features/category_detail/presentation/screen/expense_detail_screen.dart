import 'dart:io';

import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final ExpenseEntity expense;
  const ExpenseDetailScreen({super.key, required this.expense});

  bool get _hasReceipt =>
      expense.receiptImage != null && expense.receiptImage!.isNotEmpty;

  void _openFullReceipt(BuildContext context) {
    if (!_hasReceipt) return;
    context.push(
      RoutesName.receiptFullScreen,
      extra: expense.receiptImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: expense.title.toString().toTitleCase(),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          children: [
          Card(
            color: AppColors.bgColor,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(text: 'Amount'),
                      SecondaryText(
                        text: 'Rs. ${expense.amount}',
                        style: context.secondaryText!.copyWith(
                          color: AppColors.redColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(text: 'Category'),
                      SecondaryText(
                        text: expense.categoryType.toString().toTitleCase(),
                        style: context.secondaryText!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(text: 'Date'),
                      SecondaryText(
                        text: expense.date.toString(),
                        style: context.secondaryText!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  if ((expense.note ?? '').isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    SmallText(text: 'Notes'),
                    SizedBox(height: 6.h),
                    SmallText(
                      maxLine: 10,
                      text: expense.note.toString().toSentenceCase(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          SmallText(text: 'Receipt'),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () => _openFullReceipt(context),
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              height: 220.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.primary),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: _hasReceipt
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(expense.receiptImage!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return _noReceipt();
                            },
                          ),
                          Positioned(
                            right: 10.w,
                            bottom: 10.h,
                            child: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.fullscreen,
                                color: AppColors.white,
                                size: 18.r,
                              ),
                            ),
                          ),
                        ],
                      )
                    : _noReceipt(),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _noReceipt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.receipt_long_outlined,
          color: AppColors.primary,
          size: 40.r,
        ),
        SizedBox(height: 8.h),
        const ExtraSmallText(text: 'No receipt attached'),
      ],
    );
  }
}
