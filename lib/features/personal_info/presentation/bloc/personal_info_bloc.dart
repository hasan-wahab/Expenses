import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/features/personal_info/domain/usecases/personal_usecases.dart';
import 'package:expense_app/features/personal_info/presentation/bloc/personal_info_events.dart';
import 'package:expense_app/features/personal_info/presentation/bloc/personal_info_states.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/enums.dart';

class PersonalInfoBloc extends Bloc<PersonalInfoEvents, PersonalInfoStates> {
  PersonalUseCases useCases;
  PersonalInfoBloc({required this.useCases})
    : super(GetProfileImageState(status: Status.initial)) {
    on<PickImageEvent>(_pickImageEvent);
    on<UpdatePersonalInfoEvent>(_updateUserEvent);
  }

  FutureOr<void> _pickImageEvent(
    PickImageEvent event,
    Emitter<PersonalInfoStates> emit,
  ) async {
    try {
      emit(GetProfileImageState(status: Status.loading));
      XFile? imagePath = await useCases.pickImageCall(source: event.source);
      emit(GetProfileImageState(status: Status.success, imagePath: imagePath));
    } catch (e) {
      emit(GetProfileImageState(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _updateUserEvent(
    UpdatePersonalInfoEvent event,
    Emitter<PersonalInfoStates> emit,
  ) async {
    try {
      emit(UpdatePersonalInfoState(status: Status.loading));
      await useCases.updateUser(entityModel: event.entityModel);
      await Future.delayed(Duration(seconds: 3));
      emit(
        UpdatePersonalInfoState(
          status: Status.success,
          message: 'Updated Successfully',
        ),
      );
    } catch (e) {
      emit(
        UpdatePersonalInfoState(status: Status.error, message: e.toString()),
      );
    }
  }
}
