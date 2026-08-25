import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/constant/wrapers.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_expenses/presentation/screen/add_expenses_screen.dart';
import 'package:expense_app/features/dashboard/presentation/screen/dashboard_screen.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_events.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_states.dart';
import 'package:expense_app/features/settings/presentation/screen/settings_screen.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/const_text/dashboard_text.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/extensions/context_extension.dart';

class NaveBar extends StatelessWidget {
  const NaveBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NaveBarBloc>(),
      child: BlocBuilder<NaveBarBloc, NaveBarStates>(
        builder: (context, state) {
          final screens = [
            DashboardScreen(key: ValueKey(state.homeRefreshKey)),
            AddExpensesScreen(
              propertyCardId: '',
              mode: AddExpenseMode.fromNavBar,
            ),
            SettingsScreen(),
          ];

          final navItems = [
            _NavItemData(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
              isSelected: state.index == 0,
              onTap: () =>
                  context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 0)),
            ),
            _NavItemData(
              icon: Icons.add_circle_outline,
              activeIcon: Icons.add_circle,
              label: 'Add Expense',
              isSelected: state.index == 1,
              onTap: () =>
                  context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 1)),
            ),
            _NavItemData(
              icon: Icons.add_home_work_outlined,
              activeIcon: Icons.add_home_work,
              label: DashboardText.addPropertyShort,
              isSelected: false,
              onTap: () async {
                final result = await context.push(
                  RoutesName.addPropertyScreen,
                  extra: AppPropertyArgs(mode: AddPropertyMode.add),
                );
                if (result == true && context.mounted) {
                  context.read<NaveBarBloc>().add(NaveBarRefreshHomeEvent());
                }
              },
            ),
            _NavItemData(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: 'Settings',
              isSelected: state.index == 2,
              onTap: () =>
                  context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 2)),
            ),
          ];

          return PopScope(
            canPop: state.index == 0,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 0));
            },
            child: Scaffold(
              body: screens.elementAt(state.index),
              bottomNavigationBar: SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  height: 65.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: .center,
                    mainAxisAlignment: .spaceBetween,
                    children: navItems
                        .map((item) => _NavBarItem(item: item))
                        .toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
}

class _NavBarItem extends StatelessWidget {
  final _NavItemData item;
  const _NavBarItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isSelected ? context.iconAccent : context.iconMuted;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.isSelected ? item.activeIcon : item.icon,
              color: color,
            ),
            SizedBox(height: 2.h),
            ExtraSmallText(
              text: item.label,
              style: TextStyle(
                color: color,
                fontSize: 10.sp,
                fontWeight: item.isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
