import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/features/onboarding/data/onboarding_local.dart';
import 'package:get_it/get_it.dart';

class OnboardingDiModule implements DIModule {
  OnboardingDiModule(this.sl);

  final GetIt sl;

  @override
  Future<void> init() async {
    sl.registerLazySingleton<OnboardingLocal>(
      () => OnboardingLocal(sqfLiteCurd: sl<SqfLiteCurd>()),
    );
  }
}
