import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/features/settings/data/local.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_events.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_states.dart';

import '../../../../core/constant/enums.dart';

class SettingsBloc extends Bloc<SettingsEvents, SettingsStates> {
  SettingsLocalRepo localRepo;

  SettingsBloc({required this.localRepo}) : super(SettingsStates()) {
    on<OnSettingsEvent>(_onSettings);
  }

  FutureOr<void> _onSettings(
    OnSettingsEvent event,
    Emitter<SettingsStates> emit,
  ) async {
    try {
      final isFingerToggle = event.isFingerPrintEnable != null;

      /// Fingerprint toggle: keep profile on screen, no loading flash
      if (isFingerToggle) {
        final current = state is SettingsDataStates
            ? (state as SettingsDataStates).entityModel
            : SettingsEntityModel();
        final wantEnable = event.isFingerPrintEnable!;

        /// Instant UI update — no spinner on switch
        emit(
          SettingsDataStates(
            entityModel: current.copyWith(isEnableFingerPrint: wantEnable),
            status: Status.success,
          ),
        );

        final currentlyOn = await localRepo.getFingerPrint();
        if (wantEnable && !currentlyOn) {
          await localRepo.addFingerPrint();
        } else if (!wantEnable && currentlyOn) {
          await localRepo.removeFingerPrint();
        }

        final isEnable = await localRepo.getFingerPrint();
        if (isEnable != wantEnable) {
          emit(
            SettingsDataStates(
              entityModel: current.copyWith(isEnableFingerPrint: isEnable),
              status: Status.success,
            ),
          );
        }
        return;
      }

      /// First open / refresh: show loading until profile is ready
      emit(
        SettingsDataStates(
          entityModel: SettingsEntityModel(),
          status: Status.loading,
        ),
      );

      final model = await localRepo.settingsProfileCardData();
      final isEnable = await localRepo.getFingerPrint();

      emit(
        SettingsDataStates(
          entityModel: model.copyWith(isEnableFingerPrint: isEnable),
          status: Status.success,
        ),
      );
    } catch (e) {
      emit(
        SettingsDataStates(
          entityModel: SettingsEntityModel(),
          status: Status.error,
        ),
      );
    }
  }
}
