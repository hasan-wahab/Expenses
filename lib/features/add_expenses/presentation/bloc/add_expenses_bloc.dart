import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/add_expenses/domain/usescases/add_expense_usecases.dart';
import 'package:expense_app/features/add_expenses/presentation/bloc/add_expenses_event.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:image_picker/image_picker.dart';

import 'add_expenses_states.dart';

class AddExpensesBloc extends Bloc<AddExpensesEvent, AddExpensesStates> {
  final AddExpenseUseCases useCases;
  AddExpensesBloc({required this.useCases}) : super(AddExpensesInitial()) {
    on<AddNewCategoryEvent>(_addNewCategoryEvent);
    on<GetNewCategoryEvent>(_getNewCategoryEvent);
    on<SaveExpensesEvent>(_saveExpensesEvent);
    on<SelectCategoryEvent>(_selectCategoryEvent);
    on<GetPropertyCardEvent>(_getPropertyCardEvent);
    on<OnPickReceiptImageEvent>(_onPickReceiptImageEvent);
  }

  FutureOr<void> _addNewCategoryEvent(
    AddNewCategoryEvent event,
    Emitter<AddExpensesStates> emit,
  ) async {
    await useCases.addCategoryCall(categoryName: event.categoryName);
    final result = await useCases.getCategoriesCall();
    emit(GetNewCategoryState(categoryList: result));
  }

  FutureOr<void> _getNewCategoryEvent(
    GetNewCategoryEvent event,
    Emitter<AddExpensesStates> emit,
  ) async {
    final result = await useCases.getCategoriesCall();
    emit(GetNewCategoryState(categoryList: result));
  }

  FutureOr<void> _saveExpensesEvent(
    SaveExpensesEvent event,
    Emitter<AddExpensesStates> emit,
  ) async {
    try {
      emit(SaveExpensesState(status: Status.loading));

      await useCases.addNewExpenseCall(
        entityModel: event.expenseEntity,
        propertyOwnerUid: event.propertyOwnerUid,
        isSharedWithMe: event.isSharedWithMe,
      );

      emit(SaveExpensesState(status: Status.success));
    } catch (e) {
      emit(SaveExpensesState(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _selectCategoryEvent(
    SelectCategoryEvent event,
    Emitter<AddExpensesStates> emit,
  ) async {
    emit(GetSelectedCategoryState(selectedCategory: event.categoryName));
  }

  FutureOr<void> _getPropertyCardEvent(
    GetPropertyCardEvent event,
    Emitter<AddExpensesStates> emit,
  ) async {
    try {
      emit(GetPropertyCardState(status: Status.loading));
      List<DashboardCardEntity> propertyList = await useCases
          .getPropertyCardCall();
      emit(
        GetPropertyCardState(
          status: Status.success,
          propertyCardList: propertyList,
        ),
      );
    } catch (e) {
      emit(GetPropertyCardState(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _onPickReceiptImageEvent(
    OnPickReceiptImageEvent event,
    Emitter<AddExpensesStates> emit,
  ) async {
    XFile? imagePath;
    try {
      emit(PickReceiptImageState(status: Status.loading));
      if (event.imageSource == ImageSource.gallery) {
        imagePath = await useCases.galleryImageCall();
      } else {
        imagePath = await useCases.cameraImageCall();
      }
      emit(PickReceiptImageState(status: Status.success, imagePath: imagePath));
    } catch (e) {
      emit(
        PickReceiptImageState(status: Status.error, message: e.toString()),
      );
    }
  }
}
