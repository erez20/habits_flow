import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

class HabitCollectionState extends Equatable {
  final List<HabitEntity> habits;
  final GroupEntity group;
  final bool init;

  const HabitCollectionState({required this.habits, required this.group, required this.init});

  @override
  List<Object?> get props => [habits, group, init];

  HabitCollectionState copyWith({
    List<HabitEntity>? habits,
    GroupEntity? group,
    bool? init,
  }) {
    return HabitCollectionState(
      habits: habits ?? this.habits,
      group: group ?? this.group,
      init: init ?? this.init,
    );
  }
}
