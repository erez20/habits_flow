import 'dart:async';

import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:rxdart/rxdart.dart';

abstract class ActiveHabitsManager {
  Stream<void> listenToDrownHabit(String id);

  void habitDrown(String id);

  Stream<HabitEntity?> get listenToHabitSelected;

  void habitSelected({required HabitEntity habit});

  void clearHabitSelection();

  void dispose();
}

class ActiveHabitsManagerImpl implements ActiveHabitsManager {
  final BehaviorSubject<String> _drawOverHabit = BehaviorSubject<String>();
  final BehaviorSubject<HabitEntity?> _habitSelected = BehaviorSubject<HabitEntity?>();

  @override
  Stream<String> listenToDrownHabit(String id) =>
      _drawOverHabit.stream.where((element) => element == id);

  @override
  void habitDrown(String id) => _drawOverHabit.add(id);

  @override
  Stream<HabitEntity?> get listenToHabitSelected => _habitSelected.stream;

  @override
  void habitSelected({required HabitEntity habit}) =>
      _habitSelected.add(habit);

  @override
  void dispose() {
    _drawOverHabit.close();
    _habitSelected.close();
  }

  @override
  void clearHabitSelection() => _habitSelected.add(null);
}
