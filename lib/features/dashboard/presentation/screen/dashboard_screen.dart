import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';

import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_events.dart';
import 'package:expense_app/features/widgets/app_b_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/constant/wrapers.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/storage/sqflite_curd.dart';
import '../../../widgets/cusom_appbar.dart';
import '../../../widgets/add_new_floating_btn.dart';
import '../../../widgets/no_property_added.dart';
import '../../domain/entitity/dashboard_card_entity.dart';
import '../bloc/dashboard_states.dart';
import '../widgets/home_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DashboardCardEntity> list = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(GetPropertiesEvent()),
      child: BlocConsumer<DashboardBloc, DashboardStates>(
        listener: (context, state) {
          if (state is GetProperties) {
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }
            if (state.status == Status.success) {
              print(state.status);
              context.pop();
              list = state.propertyList;
            }
            if (state.status == Status.error) {
              context.pop();
              print(state.errorMessage);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: CustomAppBar(title: DashboardText.appBarText),
            body: list.isEmpty
                ? NoPropertyAdded()
                : ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: Column(
                          children: [
                            /// Card
                            HomeCard(entity: list[index]),
                          ],
                        ),
                      );
                    },
                  ),
            floatingActionButton: AddNewFloatingButton(
              isExtended: false,
              text: DashboardText.addNew,
              onTap: () async {
                /// Navigate to Add Property screen and wait for result.
                /// If user successfully adds a property, screen will return true
                /// using context.pop(true).
                /// Based on this result, we refresh the dashboard list.
                final result = await context.push(
                  RoutesName.addPropertyScreen,
                  extra: AppPropertyArgs(mode: AddPropertyMode.add),
                );
                if (result == true) {
                  /// Refresh property list after successful addition
                  if (!context.mounted) return;
                  context.read<DashboardBloc>().add(GetPropertiesEvent());
                }
              },
            ),
          );
        },
      ),
    );
  }
}
