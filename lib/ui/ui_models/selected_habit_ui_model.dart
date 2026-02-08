import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';

class SelectedHabitUiModel extends Equatable {
  final String title;
  final String habitId;
  final MaterialColor color;

  const SelectedHabitUiModel({
    required this.title,
    required this.habitId,
    required this.color,
  });

  @override
  List<Object?> get props => [title, habitId];

  factory SelectedHabitUiModel.fromHabit(HabitEntity habit) =>
      SelectedHabitUiModel(
        title: habit.title,
        habitId: habit.id,
        color: AppColors.getMaterialColor(habit.groupColor),
      );
}
