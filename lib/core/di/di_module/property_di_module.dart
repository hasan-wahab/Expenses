import 'package:expense_app/core/data_source/local_image_source/image_source_repo.dart';
import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:expense_app/core/utils/image_picker.dart';
import 'package:expense_app/features/add_property/domain/usescases/add_property_usecases.dart';
import 'package:expense_app/features/add_property/presentation/bloc/add_property_bloc.dart';
import 'package:expense_app/features/dashboard/data/property_repo.dart';
import 'package:get_it/get_it.dart';

class PropertyDiModule implements DIModule {
  final GetIt sl;
  PropertyDiModule(this.sl);
  @override
  Future<dynamic> init() async {
    sl.registerLazySingleton(
      () => AddPropertyUseCases(
        propertyRepo: sl<PropertyRepo>(),
        imageSourceRepo: sl<LocalImageSource>(),
      ),
    );
    sl.registerFactory(
      () => AddPropertyBloc(useCases: sl<AddPropertyUseCases>()),
    );
  }
}
