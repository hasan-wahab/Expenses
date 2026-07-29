import 'dart:io';
import 'dart:math';

import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_events.dart';

import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/constant/wrapers.dart';
import '../../../../core/data_source/expense_data_source/expense_local_source.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/router/routes_name.dart';
import '../../../add_expenses/domain/entitity/add_expense_entity_model.dart';

class HomeCard extends StatelessWidget {
  final DashboardCardEntity entity;
  const HomeCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    print(entity.cardId);
    return SizedBox(
      height: 218.h,
      width: 350.w,
      child: Card(
        surfaceTintColor: AppColors.primaryDark,
        borderOnForeground: true,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.iconsColor,
        color: AppColors.bgColor,
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisAlignment: .spaceBetween,
            children: [
              /// Card Header
              SizedBox(
                width: double.infinity,
                height: 80.h,
                child: Row(
                  crossAxisAlignment: .start,
                  spacing: 16.w,
                  children: [
                    /// Image Container
                    Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: .circular(12.r),
                          border: .all(width: 2.w, color: AppColors.white),
                        ),
                        height: 80.h,
                        width: 80.w,
                        child: ClipRRect(
                          borderRadius: .circular(12.r),
                          child: entity.imageUrl != ''
                              ? Image.file(
                                  File(entity.imageUrl),
                                  fit: .cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image);
                                  },
                                )
                              : Icon(Icons.image),
                        ),
                      ),
                    ),

                    /// Name And Location Name
                    Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .start,

                      children: [
                        SecondaryText(text: entity.propertyName),
                        Row(
                          mainAxisAlignment: .start,
                          mainAxisSize: .min,
                          children: [
                            Icon(Icons.location_on_outlined),
                            SmallText(text: entity.propertyLocation),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Card(
                      child: PopupMenuButton<String>(
                        surfaceTintColor: AppColors.primary,
                        borderRadius: .circular(12.r),
                        icon: Icon(Icons.more_vert), // 3 dots
                        onSelected: (value) async {
                          switch (value) {
                            case 'add expense':
                              final result = await context.push(
                                RoutesName.addExpenseScreen,
                                extra: entity.cardId.toString(),
                              );
                              if (result == true) {
                                if (!context.mounted) return;
                                context.read<DashboardBloc>().add(
                                  GetPropertiesEvent(),
                                );
                              }
                              break;
                            case 'summary':
                              context.push(
                                RoutesName.monthlySummary,
                                extra: entity.cardId,
                              );
                              break;
                            case 'edit':
                              final result = await context.push(
                                RoutesName.addPropertyScreen,
                                extra: AppPropertyArgs(
                                  mode: AddPropertyMode.update,
                                  cardEntity: entity,
                                ),
                              );
                              if (result == true) {
                                if (!context.mounted) return;
                                context.read<DashboardBloc>().add(
                                  GetPropertiesEvent(),
                                );
                              }
                              break;
                            case 'delete':
                              context.showConfirmationDialog(
                                onYesPressed: () =>
                                    context.read<DashboardBloc>().add(
                                      DeletePropertyEvent(
                                        propertyEntity: entity.copyWith(
                                          isDeleted: true,
                                        ),
                                      ),
                                    ),
                                message:
                                    'Are you sure you want to delete this property "${entity.propertyName}"?',
                              );
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'add expense',
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text('Add Expense'),
                                Icon(Icons.arrow_forward_ios, size: 15.r),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'summary',
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text('Summary'),
                                Icon(Icons.arrow_forward_ios, size: 15.r),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text('Edit'),
                                Icon(Icons.arrow_forward_ios, size: 15.r),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text('Delete'),
                                Icon(Icons.arrow_forward_ios, size: 15.r),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Card Footer
              SizedBox(
                height: 88.h,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: .spaceBetween,
                  crossAxisAlignment: .start,
                  children: [
                    /// This month expenses and Budget
                    SmallText(text: DashboardText.totalExpense),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        SecondaryText(
                          text: entity.monthlyExpenses.toString(),
                          style: context.secondaryText!.copyWith(
                            color: entity.progress! < 100
                                ? AppColors.primary
                                : AppColors.redColor,
                          ),
                        ),
                        SmallText(
                          style: entity.progress! < 100
                              ? null
                              : context.smallText!.copyWith(
                                  color: AppColors.redColor,
                                ),
                          text:
                              DashboardText.budget +
                              entity.monthlyBudget.toString(),
                        ),
                      ],
                    ),

                    /// Budget progress
                    LinearProgressIndicator(
                      minHeight: 12.h,
                      backgroundColor: AppColors.white,

                      value: entity.progress!.toDouble() / 100,
                      valueColor: AlwaysStoppedAnimation(
                        entity.progress! < 100
                            ? AppColors.primary
                            : AppColors.redColor,
                      ),
                      borderRadius: .circular(10.r),
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        if (entity.progress! > 100)
                          Row(
                            spacing: 5.w,
                            mainAxisSize: .min,
                            crossAxisAlignment: .start,
                            children: [
                              Icon(
                                Icons.warning_amber,
                                color: AppColors.redColor,
                              ),
                              SmallText(
                                text: DashboardText.overBudget,
                                style: context.smallText!.copyWith(
                                  color: AppColors.redColor,
                                  fontWeight: .bold,
                                ),
                              ),
                            ],
                          )
                        else
                          SizedBox(),
                        SmallText(
                          text: '${entity.progress!.toInt()}%',
                          style: context.smallText!.copyWith(
                            color: entity.progress! < 100
                                ? AppColors.primary
                                : AppColors.redColor,
                            fontWeight: .bold,
                          ),
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
}
