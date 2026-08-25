import 'package:expense_app/core/data_source/local_image_source/image_source_repo.dart';
import 'package:expense_app/features/add_expenses/data/expenses_repo.dart';
import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/expense_model.dart';

class AddExpenseUseCases {
  ExpensesRepo expensesRepo;
  LocalImageSource imageSourceRepo;

  AddExpenseUseCases({
    required this.expensesRepo,
    required this.imageSourceRepo,
  });

  Future addCategoryCall({required String categoryName}) async {
    await expensesRepo.addNewCategory(categoryName);
  }

  Future<List<String>> getCategoriesCall() async {
    List<String> categories = [];
    categories = await expensesRepo.getCategories();
    return categories;
  }

  Future addNewExpenseCall({
    required ExpenseEntity entityModel,
    String? propertyOwnerUid,
    bool isSharedWithMe = false,
  }) async {
    final receiptPath = (entityModel.receiptImage == null ||
            entityModel.receiptImage!.isEmpty)
        ? ''
        : await saveImageFileInLocalDirCall(entityModel.receiptImage!);

    await expensesRepo.addNewExpense(
      model: ExpenseModel.fromEntity(
        entityModel.copyWith(
          receiptImage: receiptPath,
          propertyOwnerId: isSharedWithMe ? propertyOwnerUid : '',
          isSharedWithMe: isSharedWithMe,
        ),
      ),
      propertyOwnerUid: propertyOwnerUid,
      isSharedWithMe: isSharedWithMe,
    );
  }

  Future<XFile?> galleryImageCall() async {
    return await imageSourceRepo.galleryImage();
  }

  Future<XFile?> cameraImageCall() async {
    return await imageSourceRepo.cameraImage();
  }

  Future<String> saveImageFileInLocalDirCall(String tempPath) async {
    return await imageSourceRepo.saveImageLocalDir(tempPath);
  }

  Future<List<DashboardCardEntity>> getPropertyCardCall() async {
    return await expensesRepo.getPropertyCard();
  }
}
