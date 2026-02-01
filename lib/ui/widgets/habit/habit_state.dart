import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

class HabitState extends Equatable {
  final HabitEntity habit;

  const HabitState({required this.habit});

  @override
  List<Object?> get props => [habit];

  factory HabitState.init({required HabitEntity habit}) =>
      HabitState(habit: habit);
}
