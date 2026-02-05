import 'package:equatable/equatable.dart';
import 'package:habits_flow/data/db/database.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

class SelectedHabitUiModel extends Equatable {
  final String title;
  final String habitId;

  const SelectedHabitUiModel({
    required this.title,
    required this.habitId,
  });

  @override
  List<Object?> get props => [title, habitId];

  factory SelectedHabitUiModel.fromHabit(HabitEntity habit) => SelectedHabitUiModel(
    title: habit.title,
    habitId: habit.id,
  );
}


