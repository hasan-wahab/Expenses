import 'package:expense_app/core/constant/const_text/add_expese_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/add_expenses/presentation/bloc/add_expenses_event.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/get_it.dart';
import '../../../widgets/app_t_field.dart';
import '../../../widgets/priamary_butn.dart';
import '../../../widgets/secondery_text.dart';
import '../bloc/add_expenses_bloc.dart';
import '../bloc/add_expenses_states.dart';

class AddExpenseCategory extends StatefulWidget {
  AddExpenseCategory({super.key});

  @override
  State<AddExpenseCategory> createState() => _AddExpenseCategoryState();
}

class _AddExpenseCategoryState extends State<AddExpenseCategory> {
  List<String> categoryName = [
    'Gas',
    'Electric',
    'Water',
    'Rent',
    'Food',
    'Other',
    'Add new',
  ];

  List<IconData> categoryIcon = [
    Icons.gas_meter,
    Icons.electric_bolt,
    Icons.water_drop,
    Icons.home,
    Icons.food_bank,
    Icons.more_vert,
    Icons.add,
  ];

  int? selectedIndex;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: .infinity,
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: .start,
        children: [
          SmallText(text: AddExpenseText.category),
          Wrap(
            runSpacing: 12.h,
            spacing: 10.w,
            alignment: .start,
            children: List.generate((categoryIcon.length), (index) {
              return InkWell(
                onTap: () async {
                  if (index + 1 != categoryIcon.length) {
                    selectedIndex = index;
                    setState(() {});
                  } else {
                    selectedIndex = null;
                    setState(() {});
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return AddNewCategoryDialogDesign(
                          onTap: () {
                            context.read<AddExpensesBloc>().add(
                              AddNewCategoryEvent(
                                categoryName: controller.text,
                              ),
                            );
                          },
                          controller: controller,
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
                    padding: .symmetric(horizontal: 10.r, vertical: 5.h),
                    decoration: BoxDecoration(
                      borderRadius: .circular(8.r),
                      border: .all(
                        width: 2,
                        color: selectedIndex != null && selectedIndex == index
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      spacing: 5.2,
                      mainAxisSize: .min,
                      children: [
                        Icon(categoryIcon[index]),
                        SmallText(
                          maxLine: 1,
                          overflow: TextOverflow.fade,
                          text: categoryName[index],
                          style: context.smallText!.copyWith(fontWeight: .w500),
                        ),
                        selectedIndex != null && selectedIndex == index
                            ? Icon(Icons.check)
                            : SizedBox.shrink(),
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
  TextEditingController controller;

  AddNewCategoryDialogDesign({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sh / 2,

      child: Material(
        borderRadius: .only(
          topLeft: .circular(12.r),
          topRight: .circular(12.r),
        ),
        color: AppColors.white,
        child: Padding(
          padding: .only(top: 20.h, left: 20.w, right: 20.w),
          child: Column(
            spacing: 20.h,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
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
