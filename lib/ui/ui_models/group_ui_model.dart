import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/widgets/edit_group_form/edit_group_form_widget.dart';

class GroupUIModel extends Equatable {
  final String id;
  final String title;
  final int weight;
  final MaterialColor color;
  final List<HabitEntity> habits;
  final int durationInSec;
  final int points;

  const GroupUIModel({
    required this.id,
    required this.title,
    required this.weight,
    required this.color,
    required this.habits,
    required this.durationInSec,
    required this.points,
  });

  factory GroupUIModel.fromEntity(GroupEntity entity) {
    return GroupUIModel(
      id: entity.id,
      title: entity.title,
      weight: entity.weight,
      color: AppColors.getMaterialColor(entity.groupColor),
      habits: entity.habits,
      durationInSec: entity.durationInSec,
      points: entity.points,
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
      _ when durationInSec > 0 && durationInSec % secInDay == 0 => '${durationInSec ~/ secInDay}',
      _ when durationInSec > 0 && durationInSec % secInHour == 0 =>
        '${durationInSec ~/ secInHour}',
      _  => "$durationInSec",
    };
  }

  EditGroupDurationType get  durationType {
    const int secInHour = 3600;
    const int secInDay = 86400;
    const int secInMonth = 2592000;
    return switch (durationInSec) {
      _ when durationInSec > 0 && durationInSec % secInMonth == 0 =>
      EditGroupDurationType.months,
      _ when durationInSec > 0 && durationInSec % secInDay == 0 => EditGroupDurationType.days,
      _ when durationInSec > 0 && durationInSec % secInHour == 0 =>
      EditGroupDurationType.hours,
      _  => EditGroupDurationType.seconds,
    };
  }

  GroupEntity toEntity() {
    return GroupEntity(
      id: id,
      title: title,
      weight: weight,
      groupColor: AppColors.getColorValue(color),
      habits: habits,
      durationInSec: durationInSec,
    );
  }
}
