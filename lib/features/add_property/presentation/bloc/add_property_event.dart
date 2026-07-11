import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class AddPropertyEvent {}

class OnPickImageEvent extends AddPropertyEvent {
  final ImageSource imageSource;
  OnPickImageEvent({required this.imageSource});
}

class OnAddPropertyCardEvent extends DashboardCardEntity
    implements AddPropertyEvent {
  OnAddPropertyCardEvent({
    required super.cardId,
    required super.propertyName,
    required super.propertyLocation,
    super.monthlyExpenses,
    required super.monthlyBudget,
    required super.categoryType,
    super.progress,
    required super.createAt,
    required super.imageUrl,
    super.updateAt,
  });
}
