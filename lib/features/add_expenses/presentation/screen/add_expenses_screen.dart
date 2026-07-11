import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/core/constant/const_text/add_expese_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/date_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:expense_app/features/add_expenses/presentation/bloc/add_expenses_bloc.dart';
import 'package:expense_app/features/add_expenses/presentation/widgets/add_expense_category.dart';
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
import '../widgets/date_selection.dart';
import '../widgets/upload_receipt_image.dart';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({super.key});

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  TextEditingController controller = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddExpensesBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CustomAppBar(title: AddExpenseText.addExpenseText),
        body: SafeArea(
          child: ListView(
            padding: .symmetric(horizontal: 20.w),
            children: [
              SizedBox(height: 24.h),

              /// Enter Amount Field
              AppTField(
                controller: controller,
                hintText: AddExpenseText.enterAmount,
                labelText: AddExpenseText.amount,
                startIcon: Icons.monetization_on,
              ),
              SizedBox(height: 24.h),

              /// Chose Category
              AddExpenseCategory(),
              SizedBox(height: 24.h),

              /// Date Field
              DateSelection(),
              SizedBox(height: 24.h),

              /// Notes Field --> Optional
              AppTField(
                isExtended: true,
                hintText: AddExpenseText.addHere,
                labelText: AddExpenseText.notes,
              ),

              SizedBox(height: 24.h),

              /// Upload Receipt Image
              UploadReceiptImage(),
              SizedBox(height: 24.h),

              /// Save Expense Button
              PrimaryButton(
                text: AddExpenseText.saveExpense,
                onTap: () async {
                  List<AddExpenseEntityModel> list = [];
                  AddExpenseEntityModel model = AddExpenseEntityModel(
                    expenseId: '1',
                    expenseCategory: 'Electric',
                    expenseAmount: '12344',
                    date: Timestamp.fromDate(DateTime.now()).toString(),
                    propertyId: '1',
                  );
                  final date = DateTime.now();
                  await firestore
                      .collection('Property')
                      .doc('hasanwahab@gmail.com')
                      .collection('PropertyList')
                      .doc('0')
                      .collection('Expenses')
                      .doc('1')
                      .set({
                        'ExpensesList': FieldValue.arrayUnion([model.toMap()]),
                      }, SetOptions(merge: true));
                  final doc = await firestore
                      .collection('Property')
                      .doc('hasanwahab@gmail.com')
                      .collection('PropertyList')
                      .doc('0')
                      .collection('Expenses')
                      .doc('1')
                      .get();
                  final data = doc.data();
                  print(data);
                  for (var element in data?['ExpensesList']) {
                    list.add(AddExpenseEntityModel.fromMap(element));
                  }
                  print(list.map((e) => e.expenseCategory));
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
