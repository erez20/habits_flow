import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';

class GroupUIModel extends Equatable {
  final String id;
  final String title;
  final int weight;
  final MaterialColor color;
  final List<HabitEntity> habits;
  final int durationInSec;

  const GroupUIModel({
    required this.id,
    required this.title,
    required this.weight,
    required this.color,
    required this.habits,
    required this.durationInSec,
  });

  factory GroupUIModel.fromEntity(GroupEntity entity) {
    return GroupUIModel(
      id: entity.id,
      title: entity.title,
      weight: entity.weight,
      color: AppColors.getMaterialColor(entity.groupColor),
      habits: entity.habits,
      durationInSec: entity.durationInSec,
    );
  }

  int get habitsCount => habits.length;

  int get completedHabits => habits.where((habit) => habit.isCompleted).length;

  @override
  List<Object?> get props => [id, title, weight, habits, color, durationInSec];

  String get hashKey =>
      Object.hash(id, title, weight, color, Object.hashAll(habits),durationInSec).toString();

}
