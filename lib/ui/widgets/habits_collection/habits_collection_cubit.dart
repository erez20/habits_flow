import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/use_cases/habit/habits_of_group_stream_use_case.dart';
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_manager.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_state.dart';

class HabitsCollectionCubit extends Cubit<HabitCollectionState> {
  final GroupEntity group;
  final HabitsOfGroupStreamUseCase habitsOfGroupStreamUseCase;
  final ActiveHabitsManager manager;
  final Set<String> _drownedHabits = {};


  HabitsCollectionCubit({
    required this.group,
    required this.habitsOfGroupStreamUseCase,
    required this.manager,
  }) : super(
         HabitCollectionState(
           habits: [],
           group: group,
           init: true
         ),
       ) {
    init();
  }

  late final StreamSubscription<List<HabitEntity>> _habitsSubscription;

  void init() {
    _habitsSubscription = habitsOfGroupStreamUseCase.stream(group.id).listen((
      event,
    ) {
      emit(state.copyWith(habits: event, init: false));
    });
  }

  void onHabitDrown(HabitEntity data) {
    var id = data.id;
    if (!_drownedHabits.contains(id)) {
      _drownedHabits.add(id);
      manager.habitDrown(id);
    }

  }

  @override
  Future<void> close() {
    _habitsSubscription.cancel();
    return super.close();
  }

  void onDrawingStarts() => _drownedHabits.clear();
}
