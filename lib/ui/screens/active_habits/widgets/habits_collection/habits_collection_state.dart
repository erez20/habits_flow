import 'package:equatable/equatable.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/habit_ui.dart';

class HabitCollectionState extends Equatable {
  final List<HabitUI> habits;
  final GroupUI group;
  final bool isInit;

  const HabitCollectionState({
    required this.habits,
    required this.group,
    required this.isInit,
  });

  factory HabitCollectionState.init({required GroupUI group}) =>
      HabitCollectionState(habits: const [], group: group, isInit: true);

  @override
  List<Object?> get props => [habits, group, isInit];

  HabitCollectionState copyWith({
    List<HabitUI>? habits,
    GroupUI? group,
    bool? isInit,
  }) {
    return HabitCollectionState(
      habits: habits ?? this.habits,
      group: group ?? this.group,
      isInit: isInit ?? this.isInit,
    );
  }
}
