import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

class HabitCollectionState extends Equatable {
  final List<HabitEntity> habits;
  final String groupId;



  const HabitCollectionState({required this.habits, required this.groupId});

  @override
  List<Object?> get props => [habits, groupId];

  HabitCollectionState copyWith({
    List<HabitEntity>? habits,
    String? groupId,
  }) {
    return HabitCollectionState(
      habits: habits ?? this.habits,
      groupId: groupId ?? this.groupId,
    );
  }
}
