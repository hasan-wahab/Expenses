import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_app/core/constant/const_text/add_expese_text.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/date_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:expense_app/features/add_expenses/presentation/bloc/add_expenses_bloc.dart';
import 'package:expense_app/features/add_expenses/presentation/widgets/add_expense_category.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/dashboard/presentation/widgets/home_card.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_events.dart';
import 'package:expense_app/features/summary/presentation/widgets/monthly_dropdown.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/get_it.dart';
import '../bloc/add_expenses_event.dart';
import '../bloc/add_expenses_states.dart';
import '../widgets/date_selection.dart';
import '../widgets/property_card_dropdown.dart';
import '../widgets/upload_receipt_image.dart';

class AddExpensesScreen extends StatefulWidget {
  AddExpenseMode mode;
  String propertyCardId;
  AddExpensesScreen({
    super.key,
    this.propertyCardId = '1',
    this.mode = AddExpenseMode.fromCard,
  });

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  TextEditingController controller = TextEditingController();
  List<DashboardCardEntity> dashboardCardList = [];
  ValueNotifier selectedCard = ValueNotifier<String?>(null);
  List<String> categoryList = [];
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Other';
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddExpensesBloc>()
        ..add(GetNewCategoryEvent())
        ..add(GetPropertyCardEvent()),
      child: BlocConsumer<AddExpensesBloc, AddExpensesStates>(
        listener: (context, state) {
          if (widget.mode == AddExpenseMode.fromCard) {
            selectedCard.value = widget.propertyCardId;
          }
          if (state is GetPropertyCardState) {
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }
            if (state.status == Status.success) {
              context.pop();
              dashboardCardList = state.propertyCardList ?? [];
            }
            if (state.status == Status.error) {
              context.pop();
              context.showSnackBar(state.message!, isError: true);
            }
          }
          if (state is GetNewCategoryState) {
            categoryList = state.categoryList ?? [];
          }
          if (state is SaveExpensesState) {
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }
            if (state.status == Status.success) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showSnackBar('Expense Added Successfully');
              if (widget.mode == AddExpenseMode.fromCard) {
                context.pop(true);
              }
            }
            if (state.status == Status.error) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showSnackBar(state.message!, isError: true);
            }
          }
          if (state is GetSelectedCategoryState) {
            selectedCategory = state.selectedCategory;
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (widget.mode == AddExpenseMode.fromNavBar) {
                context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 0));
              } else {
                context.pop();
              }
              return false;
            },
            child: Scaffold(
              backgroundColor: AppColors.bgColor,
              appBar: CustomAppBar(
                title: AddExpenseText.addExpenseText,
                leadingOnTap: () {
                  if (widget.mode == AddExpenseMode.fromNavBar) {
                    context.read<NaveBarBloc>().add(
                      NaveBarIndexEvent(index: 0),
                    );
                  } else {
                    context.pop();
                  }
                },
              ),
              body: SafeArea(
                child: ListView(
                  padding: .symmetric(horizontal: 20.w),
                  children: [
                    SizedBox(height: 24.h),
                    PropertyCardDropdown(
                      propertyCardId: selectedCard.value,
                      onSelected: (String? value) {
                        selectedCard.value = value;
                        setState(() {});
                      },
                      dashboardCardList: dashboardCardList,
                    ),
                    SizedBox(height: 24.h),

                    /// Enter Amount Field
                    AppTField(
                      keyboardType: .number,
                      controller: controller,
                      hintText: AddExpenseText.enterAmount,
                      labelText: AddExpenseText.amount,
                      startIcon: Icons.monetization_on,
                    ),
                    SizedBox(height: 24.h),

                    /// Chose Category
                    AddExpenseCategory(
                      categoryName: [
                        'Gas',
                        'Electric',
                        'Water',
                        'Home',
                        'Food',
                        ...categoryList,
                        'Other',
                        'Add new',
                      ],
                    ),
                    SizedBox(height: 24.h),

                    /// Date Field
                    DateSelection(
                      selectedDate: selectedDate.toDisplayDate(),
                      onTap: () async {
                        selectedDate =
                            (await context.showAppDatePicker()) ??
                            DateTime.now();
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 24.h),

                    /// Notes Field --> Optional
                    AppTField(
                      controller: notesController,
                      isExtended: true,
                      hintText: AddExpenseText.addHere,
                      labelText: AddExpenseText.notes,
                    ),

                    SizedBox(height: 24.h),

                    /// Upload Receipt Image
                    // UploadReceiptImage(),
                    // SizedBox(height: 24.h),

                    /// Save Expense Button
                    PrimaryButton(
                      text: AddExpenseText.saveExpense,
                      onTap: () async {
                        if (widget.mode == AddExpenseMode.fromNavBar &&
                            selectedCard.value == null) {
                          context.showSnackBar(
                            'Please select property',
                            isError: true,
                          );
                        } else {
                          if (controller.text.isNotEmpty) {
                            ExpenseEntity model = ExpenseEntity(
                              id: DateTime.now().microsecondsSinceEpoch,
                              createAt: DateTime.now().toString(),
                              syncStatus: SyncStatus.pending.toString(),
                              categoryType: selectedCategory,
                              date: selectedDate.toDisplayDate(),
                              note: notesController.text,
                              amount: double.parse(controller.text),
                              propertyCardId: int.parse(selectedCard.value),
                              title: selectedCategory,
                              isDeleted: 0,
                            );
                            context.read<AddExpensesBloc>().add(
                              SaveExpensesEvent(expenseEntity: model),
                            );
                          } else {
                            context.showSnackBar(
                              'Please enter amount',
                              isError: true,
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
