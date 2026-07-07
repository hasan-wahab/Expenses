import 'dart:math';

import 'package:expense_app/core/constant/const_text/settings_screen_text.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_events.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_states.dart';
import 'package:expense_app/features/settings/presentation/widgets/export_card.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/get_it.dart';
import '../widgets/account_settings.dart';
import '../widgets/min_profile_info_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool value = false;
  bool isLoading = false;
  SettingsEntityModel entityModel = SettingsEntityModel();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsBloc>()..add(OnSettingsEvent()),
      child: BlocConsumer<SettingsBloc, SettingsStates>(
        listener: (context, state) {
          if (state is SettingsDataStates) {
            if (state.status == Status.loading) {
              isLoading = true;
            }
            if (state.status == Status.success) {
              isLoading = false;
              entityModel = state.entityModel;
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: SettingsScreenText.appBarText,
              profileImagePath: '',
            ),
            body: ListView(
              padding: .symmetric(horizontal: 20.w),
              children: [
                SizedBox(height: 24.h),

                /// Min Profile Info Card
                MinProfileInfoCard(entityModel: entityModel),
                SizedBox(height: 24.h),
                AccountSettings(value: entityModel.isEnableFingerPrint),
                SizedBox(height: 24.h),

                /// Export to pdf Print Card
                ExportCard(),
                SizedBox(height: 40.h),
                PrimaryButton(text: SettingsScreenText.logout, onTap: () {}),
              ],
            ),
          );
        },
      ),
    );
  }
}
