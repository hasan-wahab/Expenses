
import '../../../add_expenses/domain/entitity/add_expense_entity_model.dart';
import '../../data/summary_repo.dart';
import '../entitity/summary_entity_model.dart';

class SummaryUseCases {
  SummaryRepo summaryRepo;

  SummaryUseCases({required this.summaryRepo});

  Future<SummaryEntityModel> getSummaryData({
    required int propertyCardId,
  }) async {
    return await summaryRepo.getSummaryData(propertyCardId: propertyCardId);
  }

  Future<List<ExpenseEntity>> getAllExpenses({
    required int propertyCardId,
  }) async {
    return await summaryRepo.getAllExpenses(propertyCardId: propertyCardId);
  }
}
