import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/ui_models/habit_ui.dart';

class SelectedHabitUI extends Equatable {
  final String id;
  final String title;
  final String info;
  final String link;
  final double weight;
  final int completionCount;
  final int points;
  final MaterialColor color;

  const SelectedHabitUI({
    required this.title,
    required this.id,
    required this.color,
    required this.info,
    required this.link,
    required this.points,
    required this.weight,
    required this.completionCount,
  });

  factory SelectedHabitUI.fromHabit(HabitUI habit) => SelectedHabitUI(
        title: habit.title,
        id: habit.id,
        color: habit.color,
        info: habit.info,
        link: habit.link,
        points: habit.points,
        weight: habit.weight,
        completionCount: habit.completionCount,
      );

  SelectedHabitUI copyWith({
    String? id,
    String? title,
    String? info,
    String? link,
    double? weight,
    int? completionCount,
    int? points,
    MaterialColor? color,
  }) {
    return SelectedHabitUI(
      id: id ?? this.id,
      title: title ?? this.title,
      info: info ?? this.info,
      link: link ?? this.link,
      weight: weight ?? this.weight,
      completionCount: completionCount ?? this.completionCount,
      points: points ?? this.points,
      color: color ?? this.color,
    );
  }

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

  @override
  List<Object?> get props =>
      [id, title, weight, completionCount, info, link, points, color];
}
