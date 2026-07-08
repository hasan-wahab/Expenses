import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/enums.dart';
import '../../domain/usescases/add_property_usecases.dart';
import 'add_property_event.dart';
import 'add_property_states.dart';

class AddPropertyBloc extends Bloc<AddPropertyEvent, AddPropertyStates> {
  AddPropertyUseCases useCases;
  AddPropertyBloc({required this.useCases}) : super(AddPropertyInitialState()) {
    on<OnPickImageEvent>(_onCameraImageEvent);
    on<OnAddPropertyCardEvent>(_onAddPropertyCardEvent);
  }
  File? image;
  FutureOr<void> _onCameraImageEvent(
    OnPickImageEvent event,
    Emitter<AddPropertyStates> emit,
  ) async {
    try {
      emit(PickImageState(status: Status.loading));
      if (event.imageSource == ImageSource.gallery) {
        image = await useCases.galleryImage();
        emit(PickImageState(status: Status.success, image: image));
      } else {
        image = await useCases.cameraImage();
        emit(PickImageState(status: Status.success, image: image));
      }
    } catch (e) {
      emit(PickImageState(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _onAddPropertyCardEvent(
    OnAddPropertyCardEvent event,
    Emitter<AddPropertyStates> emit,
  ) async {
    try {
      await useCases.saveProperty(model: event.model);
      emit(
        GetPropertyCardState(
          status: Status.success,
          message: 'Property Added Successfully',
        ),
      );
    } catch (e) {
      emit(GetPropertyCardState(status: Status.error, message: e.toString()));
    }
  }
}
