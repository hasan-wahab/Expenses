import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';

import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_events.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_events.dart';
import 'package:expense_app/features/nave_bar/presentation/bloc/nave_bar_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/constant/wrapers.dart';
import '../../../../core/di/get_it.dart';
import '../../../widgets/app_shimmer.dart';
import '../../../widgets/cusom_appbar.dart';
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
  bool _hasLoadedOnce = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(GetPropertiesEvent()),
      child: BlocListener<NaveBarBloc, NaveBarStates>(
        listenWhen: (previous, current) =>
            previous.homeRefreshKey != current.homeRefreshKey,
        listener: (context, _) {
          context.read<DashboardBloc>().add(GetPropertiesEvent());
        },
        child: BlocConsumer<DashboardBloc, DashboardStates>(
          listener: (context, state) {
            if (state is GetProperties) {
              if (state.status == Status.success) {
                list = state.propertyList;
                _hasLoadedOnce = true;
              }
              if (state.status == Status.error) {
                _hasLoadedOnce = true;
                context.showSnackBar(state.errorMessage, isError: true);
              }
            }
          },
          builder: (context, state) {
            final loading = state is DashboardInitial ||
                (state is GetProperties && state.status == Status.loading);
            final showShimmer = loading && !_hasLoadedOnce;
            return Scaffold(
              backgroundColor: AppColors.bgColor,
              appBar: CustomAppBar(
                title: DashboardText.appBarText,
                isLeading: false,
                isLoading: loading && _hasLoadedOnce,
              ),
              body: showShimmer
                  ? AppShimmer.cards()
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        context.read<DashboardBloc>().add(
                          GetPropertiesEvent(),
                        );
                      },
                      child: list.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: 480.h,
                                  child: NoPropertyAdded(
                                    onPropertyAdded: () {
                                      context.read<NaveBarBloc>().add(
                                        NaveBarIndexEvent(index: 0),
                                      );
                                      context.read<NaveBarBloc>().add(
                                        NaveBarRefreshHomeEvent(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: list.length,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              itemBuilder: (context, index) {
                                final entity = list[index];
                                return Padding(
                                  padding: EdgeInsets.only(top: 24.h),
                                  child: HomeCard(
                                    key: ValueKey(
                                      '${entity.ownerId ?? 'local'}_${entity.cardId}',
                                    ),
                                    entity: entity,
                                  ),
                                );
                              },
                            ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
