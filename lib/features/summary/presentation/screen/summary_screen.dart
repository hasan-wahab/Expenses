import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';

import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_events.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/data_source/expense_data_source/expense_local_source.dart';
import '../../../../core/di/get_it.dart';
import '../../../add_expenses/domain/entitity/add_expense_entity_model.dart';
import '../../domain/entitity/summary_entity_model.dart';
import '../bloc/summary_bloc.dart';
import '../bloc/summary_events.dart';
import '../bloc/summary_states.dart';
import '../widgets/monthly_category_breakdown.dart';
import '../widgets/monthly_dropdown.dart';
import '../widgets/monthly_expenses_overview.dart';
import '../widgets/monthly_total_expense_card.dart';

class SummaryScreen extends StatefulWidget {
  final int propertyCardId;

  const SummaryScreen({super.key, this.propertyCardId = 0});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  SummaryEntityModel? summaryEntityModel;
  List<ExpenseEntity>? expensesList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<SummaryBloc>()
            ..add(OnGetSummaryDataEvent(propertyCardId: widget.propertyCardId)),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CustomAppBar(
          title: MonthlySummaryText.summaryAppBar,
          leadingOnTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 0));
            }
          },

          actionIcon1Ontap: () {},
        ),
        body: WillPopScope(
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
                if (state.status == Status.loading) {
                  context.showCustomLoading();
                }
                if (state.status == Status.success) {
                  context.pop();
                  summaryEntityModel = state.summaryEntityModel;
                  expensesList = state.expenses;
                }
                if (state.status == Status.error) {
                  context.pop();
                  context.showSnackBar(state.message.toString());
                }
              }
            },
            builder: (context, state) {
              return summaryEntityModel != null
                  ? ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      children: [
                        SizedBox(height: 16.h),

                        // // DropDowns Button
                        // MonthlyDropdown(),
                        // SizedBox(height: 24.h),

                        // Total Expenses Card
                        MonthlyTotalExpenseCard(
                          totalExpense: summaryEntityModel!.totalExpense,
                        ),
                        SizedBox(height: 24.h),

                        /// Expenses Overview
                        MonthlyExpensesOverview(
                          monthlyExpense: summaryEntityModel!.expenses,
                        ),
                        SizedBox(height: 24.h),

                        /// Category Breakdown
                        MonthlyCategoryBreakdown(
                          expensesList: expensesList ?? [],
                          categoryBreakdown:
                              summaryEntityModel!.categoryBreakdown,
                        ),
                      ],
                    )
                  : Container();
            },
          ),
        ),
      ),
    );
  }
}
