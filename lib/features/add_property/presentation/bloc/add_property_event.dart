import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class AddPropertyEvent {}

class OnPickImageEvent extends AddPropertyEvent {
  final ImageSource imageSource;
  OnPickImageEvent({required this.imageSource});
}

class OnAddPropertyCardEvent extends AddPropertyEvent {
  DashboardCardEntity model;
  OnAddPropertyCardEvent({required this.model});
}

//
