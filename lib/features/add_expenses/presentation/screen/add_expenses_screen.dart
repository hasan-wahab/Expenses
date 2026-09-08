import 'package:expense_app/core/constant/app_currency.dart';
import 'package:expense_app/core/constant/const_text/add_expese_text.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/date_extension.dart';
import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:expense_app/features/add_expenses/presentation/bloc/add_expenses_bloc.dart';
import 'package:expense_app/features/add_expenses/presentation/widgets/add_expense_category.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_events.dart';
import 'package:expense_app/features/widgets/app_shimmer.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/get_it.dart';
import '../../../../core/extensions/text_controller_extension.dart';
import '../bloc/add_expenses_event.dart';
import '../bloc/add_expenses_states.dart';
import '../widgets/date_selection.dart';
import '../widgets/no_property_for_expense.dart';
import '../widgets/property_card_dropdown.dart';
import '../widgets/upload_receipt_image.dart';

class AddExpensesScreen extends StatefulWidget {
  AddExpenseMode mode;
  String propertyCardId;
  final String? propertyOwnerId;
  final bool isSharedWithMe;
  final String? propertyName;

  AddExpensesScreen({
    super.key,
    this.propertyCardId = '1',
    this.mode = AddExpenseMode.fromCard,
    this.propertyOwnerId,
    this.isSharedWithMe = false,
    this.propertyName,
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
  XFile? receiptImage;
  bool _propertiesLoaded = false;

  void _resetForm() {
    [controller, notesController].resetAll();
    receiptImage = null;
    selectedDate = DateTime.now();
    selectedCategory = 'Other';
    if (widget.mode == AddExpenseMode.fromNavBar) {
      selectedCard.value = null;
    }
  }

  @override
  void dispose() {
    [controller, notesController].disposeAll();
    selectedCard.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddExpensesBloc>()
        ..add(GetNewCategoryEvent())
        ..add(GetPropertyCardEvent()),
      child: BlocConsumer<AddExpensesBloc, AddExpensesStates>(
        listener: (context, state) {
          if (widget.mode == AddExpenseMode.fromCard) {
            selectedCard.value =
                '${widget.propertyOwnerId ?? ''}_${widget.propertyCardId}';
          }
          if (state is GetPropertyCardState) {
            if (state.status == Status.success) {
              dashboardCardList = state.propertyCardList ?? [];
              _propertiesLoaded = true;
              if (widget.mode == AddExpenseMode.fromCard &&
                  widget.propertyCardId.isNotEmpty &&
                  !dashboardCardList.any(
                    (e) =>
                        e.listKey ==
                        '${widget.propertyOwnerId ?? ''}_${widget.propertyCardId}',
                  )) {
                dashboardCardList = [
                  DashboardCardEntity(
                    cardId: int.tryParse(widget.propertyCardId) ?? 0,
                    propertyName: widget.propertyName ?? 'Shared property',
                    propertyLocation: '',
                    categoryType: '',
                    imageUrl: '',
                    createAt: '',
                    ownerId: widget.propertyOwnerId,
                    isSharedWithMe: widget.isSharedWithMe,
                  ),
                  ...dashboardCardList,
                ];
              }
              if (dashboardCardList.isNotEmpty &&
                  widget.mode == AddExpenseMode.fromNavBar &&
                  selectedCard.value == null &&
                  dashboardCardList.length == 1) {
                selectedCard.value = dashboardCardList.first.listKey;
              }
            }
            if (state.status == Status.error) {
              _propertiesLoaded = true;
              if (widget.mode == AddExpenseMode.fromCard &&
                  widget.propertyCardId.isNotEmpty) {
                dashboardCardList = [
                  DashboardCardEntity(
                    cardId: int.tryParse(widget.propertyCardId) ?? 0,
                    propertyName: widget.propertyName ?? 'Shared property',
                    propertyLocation: '',
                    categoryType: '',
                    imageUrl: '',
                    createAt: '',
                    ownerId: widget.propertyOwnerId,
                    isSharedWithMe: widget.isSharedWithMe,
                  ),
                ];
              }
              context.showSnackBar(state.message!, isError: true);
            }
          }
          if (state is GetNewCategoryState) {
            categoryList = state.categoryList ?? [];
          }
          if (state is PickReceiptImageState) {
            if (state.status == Status.success) {
              receiptImage = state.imagePath;
            }
            if (state.status == Status.error) {
              context.showSnackBar(state.message!, isError: true);
            }
          }
          if (state is SaveExpensesState) {
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }
            if (state.status == Status.success) {
              context.hideCustomLoading();
              _resetForm();
              setState(() {});
              context.showSnackBar('Expense Added Successfully');
              if (widget.mode == AddExpenseMode.fromCard) {
                context.pop(true);
              } else {
                context.read<NaveBarBloc>().add(NaveBarSyncHomeEvent());
              }
            }
            if (state.status == Status.error) {
              context.hideCustomLoading();
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
                isLeading: true,
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
                top: false,
                child: !_propertiesLoaded
                    ? AppShimmer.form()
                    : dashboardCardList.isEmpty
                    ? NoPropertyForExpense(
                        onPropertyAdded: () {
                          context.read<AddExpensesBloc>().add(
                            GetPropertyCardEvent(),
                          );
                        },
                      )
                    : ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                            keyboardType: TextInputType.number,
                            controller: controller,
                            hintText: AddExpenseText.enterAmount,
                            labelText: AddExpenseText.amount,
                            startText: AppCurrency.symbol,
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

                          /// Upload Receipt Image --> Optional (before notes)
                          UploadReceiptImage(
                            imagePath: receiptImage,
                            isLoading:
                                state is PickReceiptImageState &&
                                state.status == Status.loading,
                            onTap: () async {
                              final source =
                                  await context.showImageSourcePicker();
                              if (source == null || !context.mounted) return;
                              context.read<AddExpensesBloc>().add(
                                OnPickReceiptImageEvent(imageSource: source),
                              );
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
                                  final selected = dashboardCardList
                                      .where(
                                        (e) => e.listKey == selectedCard.value,
                                      )
                                      .toList();
                                  final selectedCardEntity =
                                      selected.isEmpty ? null : selected.first;
                                  final cardId =
                                      selectedCardEntity?.cardId ??
                                      int.tryParse(widget.propertyCardId) ??
                                      0;
                                  ExpenseEntity model = ExpenseEntity(
                                    id: DateTime.now().microsecondsSinceEpoch,
                                    createAt: DateTime.now().toString(),
                                    syncStatus: SyncStatus.pending.toString(),
                                    categoryType: selectedCategory,
                                    date: selectedDate.toDisplayDate(),
                                    note: notesController.text,
                                    receiptImage: receiptImage?.path ?? '',
                                    amount: double.parse(controller.text),
                                    propertyCardId: cardId,
                                    title: selectedCategory,
                                    isDeleted: 0,
                                  );
                                  context.read<AddExpensesBloc>().add(
                                    SaveExpensesEvent(
                                      expenseEntity: model,
                                      propertyOwnerUid:
                                          selectedCardEntity?.ownerId ??
                                          widget.propertyOwnerId,
                                      isSharedWithMe:
                                          selectedCardEntity?.isSharedWithMe ??
                                          widget.isSharedWithMe,
                                    ),
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
