import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

class HabitState extends Equatable {
  final HabitEntity habit;
  final bool showTooltip;

  const HabitState({required this.habit, required this.showTooltip});

  @override
  List<Object?> get props => [habit];

  factory HabitState.init({required HabitEntity habit}) =>
      HabitState(habit: habit, showTooltip: false);

  HabitState copyWith({
    HabitEntity? habit,
    bool? showTooltip,
  }) {
    return HabitState(
      habit: habit ?? this.habit,
      showTooltip: showTooltip ?? this.showTooltip,
    );
  }
}
