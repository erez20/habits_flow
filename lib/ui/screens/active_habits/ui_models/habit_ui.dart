import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/theme/app_colors.dart';

class HabitUI extends Equatable {
  final String id;
  final String title;
  final String info;
  final String link;
  final double weight;
  final int completionCount;
  final MaterialColor color;
  final int points;

  const HabitUI({
    required this.id,
    required this.title,
    required this.info,
    required this.link,
    required this.weight,
    required this.completionCount,
    required this.color,
    required this.points,
  });

  factory HabitUI.fromEntity(HabitEntity entity) => HabitUI(
        id: entity.id,
        title: entity.title,
        info: entity.info,
        link: entity.link,
        weight: entity.weight,
        completionCount: entity.completionCount,
        color: AppColors.getMaterialColor(entity.groupColor),
        points: entity.points,
      );

  HabitEntity toEntity() => HabitEntity(
        id: id,
        title: title,
        info: info,
        link: link,
        weight: weight,
        completionCount: completionCount,
        groupColor: AppColors.getColorValue(color),
        points: points,
      );

  bool get isUncompleted => completionCount == 0;

  bool get isCompleted => completionCount > 0;

  HabitUI copyWith({
    String? id,
    String? title,
    String? info,
    String? link,
    double? weight,
    int? completionCount,
    MaterialColor? color,
    int? points,
  }) {
    return HabitUI(
      id: id ?? this.id,
      title: title ?? this.title,
      info: info ?? this.info,
      link: link ?? this.link,
      weight: weight ?? this.weight,
      completionCount: completionCount ?? this.completionCount,
      color: color ?? this.color,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, info, link, weight, completionCount, color, points];
}
