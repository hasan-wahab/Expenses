import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_events.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../../core/constant/enums.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../domain/usescases/add_property_usecases.dart';
import 'add_property_event.dart';
import 'add_property_states.dart';

class AddPropertyBloc extends Bloc<AddPropertyEvent, AddPropertyStates> {
  AddPropertyUseCases useCases;
  AddPropertyBloc({required this.useCases}) : super(AddPropertyInitialState()) {
    on<OnPickImageEvent>(_onPickImageEvent);
    on<OnAddPropertyCardEvent>(_onAddPropertyCardEvent);
  }
  XFile? imagePath;
  FutureOr<void> _onPickImageEvent(
    OnPickImageEvent event,
    Emitter<AddPropertyStates> emit,
  ) async {
    try {
      if (event.imageSource == ImageSource.gallery) {
        /// Initial State Loading
        emit(PickImageState(status: Status.loading));

        /// Pick Image From Gallery => if event is gallery
        imagePath = await useCases.galleryImage();
        emit(PickImageState(status: Status.success, imagePath: imagePath));
      } else {
        /// Initial State Loading
        emit(PickImageState(status: Status.loading));

        /// Pick Image From Camera => if event is camera
        imagePath = await useCases.cameraImage();
        emit(PickImageState(status: Status.success, imagePath: imagePath));
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
      /// Initial State
      emit(GetAddedPropertyCardState(status: Status.loading));
      if (event.imageUrl.isEmpty &&
          event.imageUrl == '' &&
          event.propertyName.isEmpty &&
          event.propertyName == '' &&
          event.propertyLocation.isEmpty &&
          event.propertyLocation == '' &&
          event.monthlyBudget == 0.0 &&
          event.monthlyBudget == 0.0 &&
          event.categoryType.isEmpty &&
          event.categoryType == '') {
        emit(
          GetAddedPropertyCardState(
            status: Status.error,
            message: 'Please enter required fields!.All fields are required',
          ),
        );
      } else {
        /// Save Image in Device Directory Storage
        String imagePath = await useCases.saveImageFileInLocalDir(
          event.imageUrl,
        );

        /// Create Property Card Entity
        DashboardCardEntity model = DashboardCardEntity(
          cardId: event.cardId,
          propertyName: event.propertyName,
          propertyLocation: event.propertyLocation,
          monthlyExpenses: event.monthlyExpenses,
          monthlyBudget: event.monthlyBudget,
          categoryType: event.categoryType,
          imageUrl: imagePath,
          createAt: event.createAt,
          updateAt: event.updateAt,
        );

        /// Save Property in Firebase and Local Storage
        await useCases.saveProperty(model: model);
        emit(
          GetAddedPropertyCardState(
            status: Status.success,
            message: 'Property Added Successfully',
          ),
        );
      }
    } catch (e) {
      emit(
        GetAddedPropertyCardState(status: Status.error, message: e.toString()),
      );
    }
  }
}
