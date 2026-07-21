import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/common/duration/duration_type.dart';
import 'package:habits_flow/ui/ui_models/habit_ui.dart';

class GroupUI extends Equatable {
  final String id;
  final String title;
  final int weight;
  final MaterialColor color;
  final List<HabitUI> habits;
  final int durationInSec;
  final int points;

  const GroupUI({
    required this.id,
    required this.title,
    required this.weight,
    required this.color,
    required this.habits,
    required this.durationInSec,
    required this.points,
  });

  factory GroupUI.fromEntity(GroupEntity entity) {
    return GroupUI(
      id: entity.id,
      title: entity.title,
      weight: entity.weight,
      color: AppColors.getMaterialColor(entity.groupColor),
      habits: entity.habits.map(HabitUI.fromEntity).toList(),
      durationInSec: entity.durationInSec,
      points: entity.points,
    );
  }

  GroupEntity toEntity() {
    return GroupEntity(
      id: id,
      title: title,
      weight: weight,
      groupColor: AppColors.getColorValue(color),
      habits: habits.map((habit) => habit.toEntity()).toList(),
      durationInSec: durationInSec,
    );
  }

  GroupUI copyWith({
    String? id,
    String? title,
    int? weight,
    MaterialColor? color,
    List<HabitUI>? habits,
    int? durationInSec,
    int? points,
  }) {
    return GroupUI(
      id: id ?? this.id,
      title: title ?? this.title,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      habits: habits ?? this.habits,
      durationInSec: durationInSec ?? this.durationInSec,
      points: points ?? this.points,
    );
  }

  int get habitsCount => habits.length;

  int get completedHabits => habits.where((habit) => habit.isCompleted).length;

  @override
  List<Object?> get props => [
    id,
    title,
    weight,
    habits,
    color,
    durationInSec,
    points,
  ];

  String get hashKey => Object.hash(
    id,
    title,
    weight,
    color,
    Object.hashAll(habits),
    durationInSec,
    points,
  ).toString();

  String get durationValue {
    const int secInHour = 3600;
    const int secInDay = 86400;
    const int secInMonth = 2592000;
    return switch (durationInSec) {
      _ when durationInSec > 0 && durationInSec % secInMonth == 0 =>
        "${durationInSec ~/ secInMonth}",
      _ when durationInSec > 0 && durationInSec % secInDay == 0 =>
        '${durationInSec ~/ secInDay}',
      _ when durationInSec > 0 && durationInSec % secInHour == 0 =>
        '${durationInSec ~/ secInHour}',
      _ => "$durationInSec",
    };
  }

  DurationType get durationType {
    const int secInHour = 3600;
    const int secInDay = 86400;
    const int secInMonth = 2592000;
    return switch (durationInSec) {
      _ when durationInSec > 0 && durationInSec % secInMonth == 0 =>
        DurationType.months,
      _ when durationInSec > 0 && durationInSec % secInDay == 0 =>
        DurationType.days,
      _ when durationInSec > 0 && durationInSec % secInHour == 0 =>
        DurationType.hours,
      _ => DurationType.seconds,
    };
  }
}
