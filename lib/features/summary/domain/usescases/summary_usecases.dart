import '../../../add_expenses/domain/entitity/add_expense_entity_model.dart';
import '../../data/summary_repo.dart';
import '../entitity/summary_entity_model.dart';

class SummaryUseCases {
  SummaryRepo summaryRepo;

  SummaryUseCases({required this.summaryRepo});

  Future<SummaryEntityModel> getSummaryData({
    required int propertyCardId,
    String? propertyOwnerId,
    bool isSharedWithMe = false,
    double? monthlyBudget,
  }) async {
    return await summaryRepo.getSummaryData(
      propertyCardId: propertyCardId,
      propertyOwnerId: propertyOwnerId,
      isSharedWithMe: isSharedWithMe,
      monthlyBudget: monthlyBudget,
    );
  }

  Future<List<ExpenseEntity>> getAllExpenses({
    required int propertyCardId,
    String? propertyOwnerId,
    bool isSharedWithMe = false,
  }) async {
    return await summaryRepo.getAllExpenses(
      propertyCardId: propertyCardId,
      propertyOwnerId: propertyOwnerId,
      isSharedWithMe: isSharedWithMe,
    );
  }
}
