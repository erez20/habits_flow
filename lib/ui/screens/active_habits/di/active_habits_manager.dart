import 'dart:async';

import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:injectable/injectable.dart';

import 'package:rxdart/rxdart.dart';

abstract class ActiveHabitsManager {
  Stream<void> listenToDrownHabit(String id);

  void habitDrown(String id);

  Stream<HabitEntity?> get listenToHabitSelected;

  Stream<bool> get listenToCollapseExpandAll;

  Stream<int> get listenToTotalPoints;

  Stream<int> get listenToTotalCompletions;

  void updateTotalPoints(int totalPoints);

  void updateTotalCompletion(int totalPoints);

  Stream<bool> listenIsHabitSelected(String habitId);

  void collapseExpandAll({required bool shouldExpand});

  void habitSelected({required HabitEntity habit});

  void clearHabitSelection();

  void dispose();
}

@Injectable(as: ActiveHabitsManager)
class ActiveHabitsManagerImpl implements ActiveHabitsManager {
  final BehaviorSubject<String> _drawOverHabit = BehaviorSubject<String>();
  final BehaviorSubject<HabitEntity?> _habitSelected =
      BehaviorSubject<HabitEntity?>();
  final BehaviorSubject<bool> _collapseExpandAll = BehaviorSubject<bool>();
  final BehaviorSubject<int> _totalPoints = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<int> _totalCompletions = BehaviorSubject<int>.seeded(0);

  @override
  Stream<String> listenToDrownHabit(String id) =>
      _drawOverHabit.stream.where((element) => element == id);

  @override
  void habitDrown(String id) => _drawOverHabit.add(id);

  @override
  Stream<HabitEntity?> get listenToHabitSelected => _habitSelected.stream;

  @override
  Stream<bool> listenIsHabitSelected(String habitId) =>
      _habitSelected.stream.map((e) => e?.id == habitId);

  @override
  void habitSelected({required HabitEntity habit}) => _habitSelected.add(habit);

  @override
  void dispose() {
    _drawOverHabit.close();
    _habitSelected.close();
    _totalCompletions.close();
    _totalPoints.close();
  }

  @override
  void clearHabitSelection() => _habitSelected.add(null);

  @override
  void collapseExpandAll({required bool shouldExpand}) {
    _collapseExpandAll.add(shouldExpand);
  }

  @override
  Stream<bool> get listenToCollapseExpandAll => _collapseExpandAll;

  @override
  Stream<int> get listenToTotalPoints => _totalPoints.stream;

  @override
  Stream<int> get listenToTotalCompletions => _totalCompletions.stream;

  @override
  void updateTotalPoints(int totalPoints) {
    _totalPoints.add(totalPoints);
  }

  @override
  void updateTotalCompletion(int totalCompletions) {
    _totalCompletions.add(totalCompletions);
  }
}
