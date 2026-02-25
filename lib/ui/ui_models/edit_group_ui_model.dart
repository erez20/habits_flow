import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/ui_models/group_ui_model.dart';

class SelectedGroupUIModel extends Equatable {
  final String title;
  final MaterialColor color;
  final int durationInSec;

  const SelectedGroupUIModel({
    required this.title,
    required this.color,
    required this.durationInSec,

  });

  factory SelectedGroupUIModel.fromEntity(GroupEntity entity) {
    return SelectedGroupUIModel(
      title: entity.title,
      color: AppColors.getMaterialColor(entity.groupColor),
      durationInSec: entity.durationInSec,

    );
  }

  @override
  List<Object?> get props => [title, color, durationInSec];

  String get hashKey =>
      Object.hash(title, color, durationInSec).toString();

  GroupEntity toEntity({required GroupUIModel groupUiModel}) {
    return GroupEntity(
      id: groupUiModel.id,
      title: title,
      habits: groupUiModel.habits,
      groupColor:  AppColors.getColorValue(color),
      durationInSec: durationInSec,
      weight: groupUiModel.weight,
    );
  }
}
