import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/features/add_property/domain/usescases/add_property_usecases.dart';
import 'package:expense_app/features/add_property/presentation/bloc/add_property_event.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/enums.dart';
import '../../../dashboard/data/models/property_card_model.dart';
import '../../../dashboard/domain/entitity/dashboard_card_entity.dart';
import 'add_property_states.dart';

class AddPropertyBloc extends Bloc<AddPropertyEvent, AddPropertyStates> {
  AddPropertyUseCases useCases;
  AddPropertyBloc({required this.useCases}) : super(AddPropertyInitialState()) {
    on<OnPickImageEvent>(_onPickImageEvent);
    on<OnAddPropertyCardEvent>(_addNew);
    on<OnUpdatePropertyCardEvent>(_updateProperty);
  }

  FutureOr<void> _addNew(
    OnAddPropertyCardEvent event,
    Emitter<AddPropertyStates> emit,
  ) async {
    try {
      emit(GetAddedPropertyCardState(status: Status.loading));
      if (event.model.imageUrl.isEmpty ||
          event.model.imageUrl == '' ||
          event.model.imageUrl.isEmpty ||
          event.model.propertyName == '' ||
          event.model.propertyLocation.isEmpty ||
          event.model.propertyLocation == '' ||
          event.model.monthlyBudget == 0.0 ||
          event.model.monthlyBudget == 0.0 ||
          event.model.categoryType.isEmpty ||
          event.model.categoryType == '') {
        emit(
          GetAddedPropertyCardState(
            status: Status.error,
            message: 'Please enter required fields!.All fields are required',
          ),
        );
      } else {
        String path = await useCases.saveImageFileInLocalDirCall(
          event.model.imageUrl,
        );
        await useCases.addPropertyCall(
          model: event.model.copyWith(imageUrl: path),
        );
        emit(GetAddedPropertyCardState(status: Status.success));
      }
    } catch (e) {
      emit(
        GetAddedPropertyCardState(status: Status.error, message: e.toString()),
      );
    }
  }

  FutureOr<void> _onPickImageEvent(
    OnPickImageEvent event,
    Emitter<AddPropertyStates> emit,
  ) async {
    XFile? imagePath;
    try {
      if (event.imageSource == ImageSource.gallery) {
        /// Initial State Loading
        emit(PickImageState(status: Status.loading));

        /// Pick Image From Gallery => if event is gallery
        imagePath = await useCases.galleryImageCall();
        emit(PickImageState(status: Status.success, imagePath: imagePath));
      } else {
        /// Initial State Loading
        emit(PickImageState(status: Status.loading));

        /// Pick Image From Camera => if event is camera
        imagePath = await useCases.cameraImageCall();
        emit(PickImageState(status: Status.success, imagePath: imagePath));
      }
    } catch (e) {
      emit(PickImageState(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _updateProperty(
    OnUpdatePropertyCardEvent event,
    Emitter<AddPropertyStates> emit,
  ) async {
    try {
      emit(GetAddedPropertyCardState(status: Status.loading));
      await useCases.updatePropertyCall(
        model: PropertyModel.fromEntity(event.model),
        propertyCardId: event.model.cardId.toString(),
      );

      emit(
        GetAddedPropertyCardState(
          status: Status.success,
          message: 'Updated Successfully',
        ),
      );
    } catch (e) {
      emit(
        GetAddedPropertyCardState(status: Status.error, message: e.toString()),
      );
    }
  }
}
