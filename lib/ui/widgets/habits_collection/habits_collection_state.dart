import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

class HabitCollectionState extends Equatable {
  final List<HabitEntity> habits;
  final GroupEntity group;

  const HabitCollectionState({required this.habits, required this.group});

  @override
  List<Object?> get props => [habits, group];

  HabitCollectionState copyWith({
    List<HabitEntity>? habits,
    GroupEntity? group,
  }) {
    return HabitCollectionState(
      habits: habits ?? this.habits,
      group: group ?? this.group,
    );
  }
}
