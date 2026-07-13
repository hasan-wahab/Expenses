import 'package:expense_app/features/dashboard/data/models/property_card_model.dart';

abstract class PropertyRepoInter {
  /// Save
  Future save({required PropertyModel model});

  /// Get
  Future<List<PropertyModel>> get();

  /// Update
  Future update({required PropertyModel model, required String propertyCardId});

  /// Delete
  Future delete({required PropertyModel model});

  /// Add New Category
  Future addNewCategory({required String categoryName});

  /// Get Category List
  Future<List<dynamic>> getCategoryList();
}
