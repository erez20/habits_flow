import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'active_habits_screen_state.dart';

class ActiveHabitsScreenCubit extends Cubit<ActiveHabitsScreenState> {
  ActiveHabitsScreenCubit() : super(ActiveHabitsScreenState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }

  void addGroup() {
    Fimber.d('addGroup');
  }
}
