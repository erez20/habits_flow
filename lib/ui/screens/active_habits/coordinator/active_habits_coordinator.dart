import 'dart:async';

import 'package:habits_flow/ui/screens/active_habits/ui_models/habit_ui.dart';
import 'package:injectable/injectable.dart';

import 'package:rxdart/rxdart.dart';

abstract class ActiveHabitsCoordinator {
  Stream<void> listenToDrownHabit(String id);

  void habitDrown(String id);

  Stream<HabitUI?> get listenToHabitSelected;

  Stream<bool> get listenToCollapseExpandAll;

  Stream<String> get listenToGroupToggled;

  Stream<bool> listenIsHabitSelected(String habitId);

  void collapseExpandAll({required bool shouldExpand});

  void habitSelected({required HabitUI habit});

  void groupToggled(String groupId);

  void clearHabitSelection();

  void dispose();
}

@Injectable(as: ActiveHabitsCoordinator)
class ActiveHabitsCoordinatorImpl implements ActiveHabitsCoordinator {
  final BehaviorSubject<String> _drawOverHabit = BehaviorSubject<String>();
  final BehaviorSubject<HabitUI?> _habitSelected =
      BehaviorSubject<HabitUI?>();
  final BehaviorSubject<bool> _collapseExpandAll = BehaviorSubject<bool>();
  final BehaviorSubject<String> _groupToggled = BehaviorSubject<String>();

  @override
  Stream<String> listenToDrownHabit(String id) =>
      _drawOverHabit.stream.where((element) => element == id);

  @override
  void habitDrown(String id) => _drawOverHabit.add(id);

  @override
  Stream<HabitUI?> get listenToHabitSelected => _habitSelected.stream;

  @override
  Stream<String> get listenToGroupToggled => _groupToggled.stream;

  @override
  Stream<bool> listenIsHabitSelected(String habitId) =>
      _habitSelected.stream.map((e) => e?.id == habitId);

  @override
  void habitSelected({required HabitUI habit}) => _habitSelected.add(habit);

  @override
  void groupToggled(String groupId) => _groupToggled.add(groupId);

  @override
  void dispose() {
    _drawOverHabit.close();
    _habitSelected.close();
    _collapseExpandAll.close();
    _groupToggled.close();
  }

  @override
  void clearHabitSelection() => _habitSelected.add(null);

  @override
  void collapseExpandAll({required bool shouldExpand}) {
    _collapseExpandAll.add(shouldExpand);
  }

  @override
  Stream<bool> get listenToCollapseExpandAll => _collapseExpandAll;
}
