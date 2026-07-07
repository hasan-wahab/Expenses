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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/get_it.dart';
import '../../../widgets/cusom_appbar.dart';
import '../../../widgets/add_new_floating_btn.dart';
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
      create: (context) => sl<DashboardBloc>()..add(GetCardListEvent()),
      child: BlocConsumer<DashboardBloc, DashboardStates>(
        listener: (context, state) {
          if (state is GetPropertyCardState) {
            if (state.status == Status.error) {
              if (context.canPop()) {
                context.pop();
                context.showSnackBar(state.message);
              }
              context.showSnackBar(state.message);
            }
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }
            if (state.status == Status.success) {
              if (context.canPop()) {
                context.pop();
                list = state.propertyCardList;
              }
              list = state.propertyCardList;
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: CustomAppBar(
              title: DashboardText.appBarText,
              actionIcon1: Icons.notifications_none,
            ),
            body: list.isEmpty
                ? Center(child: SmallText(text: "No data found"))
                : RefreshIndicator(
                    onRefresh: () async {
                      context.read<DashboardBloc>().add(SyncDataEvent());
                    },
                    child: ListView.builder(
                      itemCount: list.length,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: Column(
                            children: [
                              /// Card
                              InkWell(
                                onTap: () {
                                  context.push(RoutesName.monthlySummary);
                                },
                                child: HomeCard(entity: list[index]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            floatingActionButton: AddNewFloatingButton(
              text: DashboardText.addNew,
              onTap: () {
                context.read<DashboardBloc>().add(
                  AddNewPropertyCardEvent(
                    model: DashboardCardEntity(
                      createAt: DateTime.now().toString(),
                      cardId: list.length + 1,
                      monthlyBudget: 1000,
                      monthlyExpenses: 200,
                      progress: 0.07,
                      propertyLocation: 'Peshawar',
                      propertyName: 'My Home',
                      categoryType: 'Cate',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
