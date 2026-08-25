import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';

class OnboardingLocal {
  OnboardingLocal({required this.sqfLiteCurd});

  final SqfLiteCurd sqfLiteCurd;

  Future<bool> isCompleted() async {
    final result = await sqfLiteCurd.get(tableKey: TableKeys.onboardingTable);
    if (result.isEmpty) return false;
    return result.first['completed'] == 1;
  }

  Future<void> markCompleted() async {
    final existing = await sqfLiteCurd.get(tableKey: TableKeys.onboardingTable);
    if (existing.isEmpty) {
      await sqfLiteCurd.save(
        tableKey: TableKeys.onboardingTable,
        value: {'completed': 1},
      );
      return;
    }
    await sqfLiteCurd.update(
      tableKey: TableKeys.onboardingTable,
      value: {'completed': 1},
    );
  }
}
