import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';

class SelectedGroupUI extends Equatable {
  final String title;
  final MaterialColor color;
  final int durationInSec;

  const SelectedGroupUI({
    required this.title,
    required this.color,
    required this.durationInSec,
  });

  factory SelectedGroupUI.fromEntity(GroupEntity entity) {
    return SelectedGroupUI(
      title: entity.title,
      color: AppColors.getMaterialColor(entity.groupColor),
      durationInSec: entity.durationInSec,
    );
  }

  SelectedGroupUI copyWith({
    String? title,
    MaterialColor? color,
    int? durationInSec,
  }) {
    return SelectedGroupUI(
      title: title ?? this.title,
      color: color ?? this.color,
      durationInSec: durationInSec ?? this.durationInSec,
    );
  }

  GroupEntity toEntity({required GroupUI groupUI}) {
    return GroupEntity(
      id: groupUI.id,
      title: title,
      habits: groupUI.habits.map((habit) => habit.toEntity()).toList(),
      groupColor: AppColors.getColorValue(color),
      durationInSec: durationInSec,
      weight: groupUI.weight,
    );
  }

  String get hashKey => Object.hash(title, color, durationInSec).toString();

  @override
  List<Object?> get props => [title, color, durationInSec];
}
