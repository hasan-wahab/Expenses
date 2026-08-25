import 'package:expense_app/features/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/get_it.dart';
import '../../../../core/router/routes_name.dart';
import '../bloc/sync_data_bloc.dart';
import '../bloc/sync_data_events.dart';
import '../bloc/sync_data_states.dart';

class SyncDataScreen extends StatelessWidget {
  bool isFingerPrint;
  SyncDataScreen({super.key, required this.isFingerPrint});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<SyncDataBloc>()..add(SyncDataEvent(isFingerPrint: isFingerPrint)),
      child: BlocConsumer<SyncDataBloc, SyncDataStates>(
        listener: (context, state) {
          if (state is SyncDataLoadedState) {
            context.go(RoutesName.naveBar);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(child: AppShimmer.sync()),
          );
        },
      ),
    );
  }
}
