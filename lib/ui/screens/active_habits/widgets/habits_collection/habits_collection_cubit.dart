import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/habit_ui.dart';
import 'package:habits_flow/domain/use_cases/habit/habits_of_group_stream_use_case.dart';
import 'package:habits_flow/ui/screens/active_habits/coordinator/active_habits_coordinator.dart';
import 'habits_collection_state.dart';

class HabitsCollectionCubit extends Cubit<HabitCollectionState> {
  final GroupUI group;
  final HabitsOfGroupStreamUseCase habitsOfGroupStreamUseCase;
  final ActiveHabitsCoordinator coordinator;
  final Set<String> _drownedHabits = {};


  HabitsCollectionCubit({
    required this.group,
    required this.habitsOfGroupStreamUseCase,
    required this.coordinator,
  }) : super(HabitCollectionState.init(group: group)) {
    init();
  }

  late final StreamSubscription<List<HabitEntity>> _habitsSubscription;

  void init() {
    _habitsSubscription = habitsOfGroupStreamUseCase.stream(group.id).listen((
      event,
    ) {
      final habits = event.map(HabitUI.fromEntity).toList();
      emit(state.copyWith(habits: habits, isInit: false));
    });
  }

  void onHabitDrown(HabitUI data) {
    var id = data.id;
    if (!_drownedHabits.contains(id)) {
      _drownedHabits.add(id);
      coordinator.habitDrown(id);
    }

  }

  @override
  Future<void> close() {
    _habitsSubscription.cancel();
    return super.close();
  }

  void onDrawingStarts() => _drownedHabits.clear();
}
