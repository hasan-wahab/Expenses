import 'dart:async';
import 'dart:math';

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
      emit(
        SettingsDataStates(
          entityModel: SettingsEntityModel(),
          status: Status.loading,
        ),
      );

      SettingsEntityModel model = await localRepo.settingsProfileCardData();

      /// Initially from local storage get
      bool isEnable = await localRepo.getFingerPrint();

      /// If event.finger !=null
      if (event.isFingerPrintEnable != null) {
        /// Then isEnable is true then remove
        if (isEnable == true) {
          await localRepo.removeFingerPrint();
        } else {
          /// Other wise add
          await localRepo.addFingerPrint();
        }
      }

      /// Here pass the new value from use add or remove
      isEnable = await localRepo.getFingerPrint();
      emit(
        SettingsDataStates(
          entityModel: SettingsEntityModel().copyWith(
            isEnableFingerPrint: isEnable,
            name: model.name,
            email: model.email,
          ),
          status: Status.success,
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
