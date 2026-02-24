import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';

class SelectedHabitUiModel extends Equatable {
  final String id;
  final String title;
  final String info;
  final String link;
  final double weight;
  final int completionCount;
  final int points;
  final MaterialColor color;




  const SelectedHabitUiModel({
    required this.title,
    required this.id,
    required this.color,
    required this.info,
    required this.link,
    required this.points,
    required this.weight,
    required this.completionCount,
  });

  @override
  List<Object?> get props => [id, title, weight, completionCount, info, link,  points, color];


  factory SelectedHabitUiModel.fromHabit(HabitEntity habit) =>
      SelectedHabitUiModel(
        title: habit.title,
        id: habit.id,
        color: AppColors.getMaterialColor(habit.groupColor),
        info: habit.info,
        link: habit.link,
        points: habit.points,
        weight: habit.weight,
        completionCount: habit.completionCount,

      );

  HabitEntity toEntity() => HabitEntity(
    id: id,
    title: title,
    info: info,
    link: link,
    points: points,
    weight: weight,
    completionCount: 0,
    groupColor: AppColors.getColorValue(color),
  );
}
