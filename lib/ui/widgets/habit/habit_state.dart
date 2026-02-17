import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

class HabitState extends Equatable {
  final HabitEntity habit;
  final bool showTooltip;
  final bool isSelected;


  const HabitState({required this.habit, required this.showTooltip, required this.isSelected,});

  @override
  List<Object?> get props => [habit, showTooltip, isSelected];

  factory HabitState.init({required HabitEntity habit}) =>
      HabitState(habit: habit, showTooltip: false, isSelected: false);

  HabitState copyWith({
    HabitEntity? habit,
    bool? showTooltip,
    bool? isSelected,
  }) {
    return HabitState(
      habit: habit ?? this.habit,
      showTooltip: showTooltip ?? this.showTooltip,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
