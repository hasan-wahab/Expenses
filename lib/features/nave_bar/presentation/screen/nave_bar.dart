import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/add_expenses/presentation/screen/add_expenses_screen.dart';
import 'package:expense_app/features/dashboard/presentation/screen/dashboard_screen.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_events.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_states.dart';
import 'package:expense_app/features/settings/presentation/screen/settings_screen.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/const_text/dashboard_text.dart';
import '../../../../core/constant/const_text/monthly_summary_text.dart';
import '../../../../core/di/get_it.dart';
import '../../../summary/presentation/screen/summary_screen.dart';

class NaveBar extends StatelessWidget {
  const NaveBar({super.key});

  List<Widget> get screens => [
    DashboardScreen(),
    AddExpensesScreen(propertyCardId: '', mode: AddExpenseMode.fromNavBar),
    SettingsScreen(),
  ];

  List<IconData> get icons => [Icons.home, Icons.add, Icons.settings];
  List<String> get name => ['Home', 'Add Expense', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NaveBarBloc>(),
      child: BlocBuilder<NaveBarBloc, NaveBarStates>(
        builder: (context, state) {
          return Scaffold(
            body: screens.elementAt(state.index),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: .symmetric(horizontal: 20.w),
                height: 65.h,
                width: .infinity,
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  boxShadow: [
                    BoxShadow(color: AppColors.primary, offset: Offset(0, -1)),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .spaceBetween,
                  children: List.generate((screens.length), (index) {
                    return InkWell(
                      onTap: () => context.read<NaveBarBloc>().add(
                        NaveBarIndexEvent(index: index),
                      ),
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          Icon(icons[index]),
                          ExtraSmallText(text: name[index]),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
