import 'dart:async';

import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:rxdart/rxdart.dart';

abstract class ActiveHabitsUIManager {
  Stream<void> listenToDrownHabit(String id);

  void addDrownHabit(String id);

  Stream<HabitEntity> get onHabitHit;
  void habitHit(HabitEntity habit);

  void dispose();
}

class ActiveHabitsUIManagerImpl implements ActiveHabitsUIManager {
  final BehaviorSubject<String> _drawOverHabit = BehaviorSubject<String>();
  final BehaviorSubject<HabitEntity> _onHabitHit = BehaviorSubject<HabitEntity>();

  @override
  Stream<void> listenToDrownHabit(String id) =>
      _drawOverHabit.stream.where((element) => element == id).map((_) {});

  @override
  void addDrownHabit(String id) => _drawOverHabit.add(id);

  @override
  Stream<HabitEntity> get onHabitHit => _onHabitHit.stream;

  @override
  void habitHit(HabitEntity habit) => _onHabitHit.add(habit);

  @override
  void dispose() {
    _drawOverHabit.close();
    _onHabitHit.close();
  }
}
