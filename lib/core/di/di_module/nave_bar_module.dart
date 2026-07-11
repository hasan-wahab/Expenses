import 'package:get_it/get_it.dart';

import '../../../features/nave_bar/presentation/bloc/nave_bar_bloc.dart';
import '../get_it.dart';
import 'di_module.dart';

class NaveBarDiModule implements DIModule {
  NaveBarDiModule(this.sl);
  GetIt sl;
  @override
  Future<void> init() async {
    /// Nave Bar Bloc
    sl.registerFactory(() => NaveBarBloc());
  }
}
