import 'dart:io';

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

  Future<void> _onAddExpense(BuildContext context) async {
    final result = await context.push(
      RoutesName.addExpenseScreen,
      extra: entity.cardId.toString(),
    );
    if (result == true) {
      if (!context.mounted) return;
      context.read<DashboardBloc>().add(GetPropertiesEvent());
    }
  }

  void _onViewSummary(BuildContext context) {
    context.push(RoutesName.monthlySummary, extra: entity.cardId);
  }

  @override
  Widget build(BuildContext context) {
    final isOverBudget = (entity.progress ?? 0) >= 100;

    return SizedBox(
      width: 350.w,
      child: Card(
        surfaceTintColor: AppColors.primaryDark,
        borderOnForeground: true,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.iconsColor,
        color: AppColors.bgColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Card Header
              SizedBox(
                width: double.infinity,
                height: 72.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.w,
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            width: 2.w,
                            color: AppColors.white,
                          ),
                        ),
                        height: 72.h,
                        width: 72.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: entity.imageUrl != ''
                              ? Image.file(
                                  File(entity.imageUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image);
                                  },
                                )
                              : const Icon(Icons.image),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SecondaryText(text: entity.propertyName),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16.r,
                                color: AppColors.iconsColor,
                              ),
                              SizedBox(width: 2.w),
                              Flexible(
                                child: SmallText(text: entity.propertyLocation),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      child: PopupMenuButton<String>(
                        surfaceTintColor: AppColors.primary,
                        borderRadius: BorderRadius.circular(12.r),
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) async {
                          switch (value) {
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
                            value: 'edit',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Edit'),
                                Icon(Icons.arrow_forward_ios, size: 15.r),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Delete'),
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

              SizedBox(height: 14.h),

              /// Expense + budget
              SmallText(text: DashboardText.totalExpense),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SecondaryText(
                    text: entity.monthlyExpenses.toString(),
                    style: context.secondaryText!.copyWith(
                      color: isOverBudget
                          ? AppColors.redColor
                          : AppColors.primary,
                    ),
                  ),
                  SmallText(
                    style: isOverBudget
                        ? context.smallText!.copyWith(color: AppColors.redColor)
                        : null,
                    text:
                        DashboardText.budget + entity.monthlyBudget.toString(),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              LinearProgressIndicator(
                minHeight: 10.h,
                backgroundColor: AppColors.white,
                value: (entity.progress ?? 0).toDouble() / 100,
                valueColor: AlwaysStoppedAnimation(
                  isOverBudget ? AppColors.redColor : AppColors.primary,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if ((entity.progress ?? 0) > 100)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: AppColors.redColor,
                          size: 16.r,
                        ),
                        SizedBox(width: 4.w),
                        SmallText(
                          text: DashboardText.overBudget,
                          style: context.smallText!.copyWith(
                            color: AppColors.redColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  SmallText(
                    text: '${(entity.progress ?? 0).toInt()}%',
                    style: context.smallText!.copyWith(
                      color: isOverBudget
                          ? AppColors.redColor
                          : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),
              Divider(
                height: 1.h,
                thickness: 1,
                color: AppColors.primary.withOpacity(0.12),
              ),
              SizedBox(height: 12.h),

              /// Actions
              Row(
                children: [
                  Expanded(
                    child: _HomeCardActionButton(
                      label: DashboardText.viewSummary,
                      icon: Icons.bar_chart_rounded,
                      isPrimary: false,
                      onTap: () => _onViewSummary(context),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _HomeCardActionButton(
                      label: DashboardText.addExpense,
                      icon: Icons.add_rounded,
                      isPrimary: true,
                      onTap: () => _onAddExpense(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCardActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _HomeCardActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          height: 40.h,
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10.r),
            border: isPrimary
                ? null
                : Border.all(
                    color: AppColors.primary.withOpacity(0.35),
                    width: 1.2,
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.r,
                color: isPrimary ? AppColors.white : AppColors.primaryDark,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.smallText!.copyWith(
                    color: isPrimary ? AppColors.white : AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
