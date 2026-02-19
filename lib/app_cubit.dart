import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_state.dart';
import 'main/injection.dart' ;

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppReady());

  Future<void> restartApp() async {
    await getIt.reset();
    configureDependencies();
    emit(AppRestarting());
  }
}
