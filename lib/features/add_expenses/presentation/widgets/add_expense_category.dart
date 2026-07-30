import 'package:expense_app/core/constant/const_text/add_expese_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/text_controller_extension.dart';
import 'package:expense_app/features/add_expenses/presentation/bloc/add_expenses_event.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/app_t_field.dart';
import '../../../widgets/priamary_butn.dart';
import '../../../widgets/secondery_text.dart';
import '../bloc/add_expenses_bloc.dart';

class AddExpenseCategory extends StatefulWidget {
  List<String> categoryName;
  AddExpenseCategory({super.key, required this.categoryName});

  @override
  State<AddExpenseCategory> createState() => _AddExpenseCategoryState();
}

class _AddExpenseCategoryState extends State<AddExpenseCategory> {
  int? selectedIndex;
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallText(text: AddExpenseText.category),
          Wrap(
            runSpacing: 12.h,
            spacing: 10.w,
            alignment: WrapAlignment.start,
            children: List.generate((widget.categoryName.length), (index) {
              return InkWell(
                onTap: () async {
                  if (index + 1 != widget.categoryName.length) {
                    selectedIndex = index;
                    setState(() {});
                    context.read<AddExpensesBloc>().add(
                      SelectCategoryEvent(
                        categoryName: widget.categoryName[index],
                      ),
                    );
                  } else {
                    selectedIndex = null;
                    setState(() {});
                    showCupertinoModalPopup(
                      context: context,
                      builder: (_) {
                        return BlocProvider.value(
                          value: context.read<AddExpensesBloc>(),
                          child: AddNewCategoryDialogDesign(
                            onTap: () {
                              context.read<AddExpensesBloc>().add(
                                AddNewCategoryEvent(
                                  categoryName: controller.text,
                                ),
                              );
                              controller.reset();
                              context.pop();
                            },
                            controller: controller,
                          ),
                        );
                      },
                    );
                  }
                },
                child: Card(
                  shadowColor: selectedIndex != null && selectedIndex == index
                      ? AppColors.white
                      : null,
                  color: selectedIndex != null && selectedIndex == index
                      ? AppColors.white
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.r,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        width: 2,
                        color: selectedIndex != null && selectedIndex == index
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      spacing: 5.2,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SmallText(
                          maxLine: 1,
                          overflow: TextOverflow.fade,
                          text: widget.categoryName[index],
                          style: context.smallText!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        selectedIndex != null && selectedIndex == index
                            ? const Icon(Icons.check)
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class AddNewCategoryDialogDesign extends StatelessWidget {
  final VoidCallback onTap;
  final TextEditingController controller;

  const AddNewCategoryDialogDesign({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sh / 2,
      child: Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
        color: AppColors.white,
        child: Padding(
          padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
          child: Column(
            spacing: 20.h,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SecondaryText(text: 'Add New Category'),
                  InkWell(onTap: () => context.pop(), child: Icon(Icons.close)),
                ],
              ),
              AppTField(
                hintText: 'Enter category name',
                labelText: 'Enter category',
                controller: controller,
              ),
              PrimaryButton(text: 'Add new', onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}
