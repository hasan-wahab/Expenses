import 'package:expense_app/core/constant/const_text/settings_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/auth/domain/usescases/auth_usecases.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_events.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_states.dart';
import 'package:expense_app/features/settings/presentation/widgets/export_card.dart';
import 'package:expense_app/features/sync_data/domain/usescases/sync_data_use_cases.dart';
import 'package:expense_app/features/widgets/app_shimmer.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/di/get_it.dart';
import '../../../nave_bar/presentation/bloc/nave_bar_bloc.dart';
import '../../../nave_bar/presentation/bloc/nave_bar_events.dart';
import '../widgets/account_settings.dart';
import '../widgets/min_profile_info_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsBloc>()..add(OnSettingsEvent()),
      child: BlocBuilder<SettingsBloc, SettingsStates>(
        builder: (context, state) {
          final isLoading =
              state is SettingsDataStates && state.status == Status.loading;
          final entityModel = state is SettingsDataStates
              ? state.entityModel
              : SettingsEntityModel();

          return WillPopScope(
            onWillPop: () async {
              context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 0));
              return false;
            },
            child: Scaffold(
              appBar: CustomAppBar(
                isLeading: true,
                leadingOnTap: () {
                  context.read<NaveBarBloc>().add(NaveBarIndexEvent(index: 0));
                },
                title: SettingsScreenText.appBarText,
              ),
              body: isLoading
                  ? AppShimmer.settings()
                  : ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      children: [
                        SizedBox(height: 24.h),
                        MinProfileInfoCard(entityModel: entityModel),
                        SizedBox(height: 24.h),
                        AccountSettings(entityModel: entityModel),
                        SizedBox(height: 24.h),
                        ExportCard(),
                        SizedBox(height: 40.h),
                        PrimaryButton(
                          text: SettingsScreenText.logout,
                          onTap: () {
                            context.showConfirmationDialog(
                              message: 'Are you sure you want to logout?',
                              onYesPressed: () async {
                                sl<SyncDataUseCases>().stopSync();
                          await sl<AuthUseCases>().logoutCall();
                          if (!context.mounted) return;
                          /// Logout → login: no auto fingerprint prompt
                          context.go(RoutesName.login, extra: true);
                              },
                            );
                          },
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
