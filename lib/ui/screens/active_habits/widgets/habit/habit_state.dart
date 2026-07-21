import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

class HabitState extends Equatable {
  final HabitEntity habit;

  final bool isSelected;

  const HabitState({
    required this.habit,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [habit, isSelected];

  factory HabitState.init({required HabitEntity habit}) =>
      HabitState(habit: habit, isSelected: false);

  HabitState copyWith({
    HabitEntity? habit,

    bool? isSelected,
  }) {
    return HabitState(
      habit: habit ?? this.habit,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
