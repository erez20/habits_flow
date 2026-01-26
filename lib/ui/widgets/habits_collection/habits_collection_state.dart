import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

class HabitCollectionState extends Equatable {
  final List<HabitEntity> habits;

  const HabitCollectionState({required this.habits});

  @override

  List<Object?> get props => [habits];
}