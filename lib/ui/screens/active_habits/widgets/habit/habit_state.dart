import 'package:equatable/equatable.dart';
import 'package:habits_flow/ui/ui_models/habit_ui.dart';

class HabitState extends Equatable {
  final HabitUI habit;

  final bool isSelected;

  const HabitState({
    required this.habit,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [habit, isSelected];

  factory HabitState.init({required HabitUI habit}) =>
      HabitState(habit: habit, isSelected: false);

  HabitState copyWith({
    HabitUI? habit,

    bool? isSelected,
  }) {
    return HabitState(
      habit: habit ?? this.habit,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
