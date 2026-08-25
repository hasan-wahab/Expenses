import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/constant/wrapers.dart';
import 'package:expense_app/core/extensions/context_extension.dart';

import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_events.dart';
import 'package:expense_app/features/widgets/app_shimmer.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/di/get_it.dart';
import '../../../add_expenses/domain/entitity/add_expense_entity_model.dart';
import '../../domain/entitity/summary_entity_model.dart';
import '../bloc/summary_bloc.dart';
import '../bloc/summary_events.dart';
import '../bloc/summary_states.dart';
import '../widgets/monthly_category_breakdown.dart';
import '../widgets/monthly_expenses_overview.dart';
import '../widgets/monthly_total_expense_card.dart';
import '../widgets/no_expense_added.dart';

class SummaryScreen extends StatefulWidget {
  final SummaryArgs args;

  const SummaryScreen({super.key, required this.args});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  SummaryEntityModel? summaryEntityModel;
  List<ExpenseEntity>? expensesList;
  bool isLoaded = false;

  OnGetSummaryDataEvent get _reloadEvent => OnGetSummaryDataEvent(
        propertyCardId: widget.args.propertyCardId,
        propertyOwnerId: widget.args.propertyOwnerId,
        isSharedWithMe: widget.args.isSharedWithMe,
        monthlyBudget: widget.args.monthlyBudget,
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SummaryBloc>()..add(_reloadEvent),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CustomAppBar(
          title: MonthlySummaryText.summaryAppBar,
          isLeading: true,
          leadingOnTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 0));
            }
          },
          actionIcon1Ontap: () {},
        ),
        body: SafeArea(
          top: false,
          child: WillPopScope(
            onWillPop: () async {
              if (context.canPop()) {
                context.pop();
              } else {
                context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 0));
              }
              return false;
            },
            child: BlocConsumer<SummaryBloc, SummaryStates>(
              listener: (context, state) {
                if (state is GetSummaryDataState) {
                  if (state.status == Status.success) {
                    summaryEntityModel = state.summaryEntityModel;
                    expensesList = state.expenses;
                    isLoaded = true;
                  }
                  if (state.status == Status.error) {
                    isLoaded = true;
                    context.showSnackBar(state.message.toString());
                  }
                }
              },
              builder: (context, state) {
                final loading =
                    state is GetSummaryDataState &&
                    state.status == Status.loading;
                if (loading || !isLoaded || summaryEntityModel == null) {
                  return AppShimmer.summary();
                }

                if (expensesList == null || expensesList!.isEmpty) {
                  return NoExpenseAdded(
                    args: widget.args,
                    onExpenseAdded: () {
                      context.read<SummaryBloc>().add(_reloadEvent);
                    },
                  );
                }

                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    SizedBox(height: 16.h),
                    MonthlyTotalExpenseCard(
                      totalExpense: summaryEntityModel!.totalExpense,
                    ),
                    SizedBox(height: 24.h),
                    MonthlyExpensesOverview(
                      monthlyExpense: summaryEntityModel!.expenses,
                    ),
                    SizedBox(height: 24.h),
                    MonthlyCategoryBreakdown(
                      expensesList: expensesList ?? [],
                      categoryBreakdown: summaryEntityModel!.categoryBreakdown,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
