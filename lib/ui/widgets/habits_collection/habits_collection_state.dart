import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

class HabitCollectionState extends Equatable {
  final List<HabitEntity> habits;
  final String groupId;
  final MaterialColor color;


  const HabitCollectionState({required this.habits, required this.groupId, required this.color});

  @override
  List<Object?> get props => [habits, groupId, color];

  HabitCollectionState copyWith({
    List<HabitEntity>? habits,
    String? groupId,
  }) {
    return HabitCollectionState(
      habits: habits ?? this.habits,
      groupId: groupId ?? this.groupId,
      color: color,
    );
  }
}
