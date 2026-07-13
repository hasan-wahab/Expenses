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
import '../../../../core/router/routes_name.dart';

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
                              context.push(RoutesName.addExpenseScreen);
                              break;
                            case 'summary':
                              context.push(RoutesName.monthlySummary);
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
                              print(entity.cardId);
                              context.read<DashboardBloc>().add(
                                DeletePropertyEvent(
                                  entity: entity.copyWith(isDeleted: true),
                                ),
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
                    SmallText(text: DashboardText.thisMonthExpense),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        SecondaryText(
                          text: entity.monthlyExpenses.toString(),
                          style: context.secondaryText!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        SmallText(
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

                      value: entity.progress,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      borderRadius: .circular(10.r),
                    ),
                    Row(
                      mainAxisAlignment: .end,
                      children: [
                        SmallText(
                          text: '${entity.progress} %',
                          style: context.smallText!.copyWith(
                            color: AppColors.primary,
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
