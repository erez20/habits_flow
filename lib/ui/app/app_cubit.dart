import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  /// Injected by main (the composition root): resets and re-wires DI.
  final Future<void> Function() onRestart;

  AppCubit({required this.onRestart}) : super(AppReady());

  Future<void> restartApp() async {
    await onRestart();
    emit(AppRestarting());
  }
}
