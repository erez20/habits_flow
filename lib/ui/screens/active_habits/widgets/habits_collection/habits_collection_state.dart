import 'package:equatable/equatable.dart';
import 'package:habits_flow/ui/ui_models/group_ui.dart';
import 'package:habits_flow/ui/ui_models/habit_ui.dart';

class HabitCollectionState extends Equatable {
  final List<HabitUI> habits;
  final GroupUI group;
  final bool init;

  const HabitCollectionState({required this.habits, required this.group, required this.init});

  @override
  List<Object?> get props => [habits, group, init];

  HabitCollectionState copyWith({
    List<HabitUI>? habits,
    GroupUI? group,
    bool? init,
  }) {
    return HabitCollectionState(
      habits: habits ?? this.habits,
      group: group ?? this.group,
      init: init ?? this.init,
    );
  }
}
