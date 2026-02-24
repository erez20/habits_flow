import 'package:equatable/equatable.dart';
import 'habit_entity.dart';

class GroupEntity extends Equatable {
  final String id;
  final String title;
  final int weight;
  final List<HabitEntity> habits;
  final int groupColor;
  final int durationInSec;
  final int points;

  GroupEntity({
    required this.id,
    required this.title,
    required this.weight,
    required this.habits,
    required this.groupColor,
    required this.durationInSec,
  }) : points = habits.fold(0, (sum, habit) => habit.isCompleted ? sum + habit.points : sum);

  @override
  List<Object?> get props => [id, title, weight, habits, groupColor, durationInSec, points];

  void addHabit(HabitEntity habit) {
    habits.add(habit);
  }

  void removeHabit(HabitEntity habit) {
    habits.remove(habit);
  }

  String get hashKey => Object.hash(id, title, weight, groupColor, durationInSec, points, Object.hashAll(habits)).toString();


  @override
  String toString() {
    return 'GroupEntity(id: ${id.substring(id.length - 6)}, title: $title)';
  }

  String get shortId=> id.substring(id.length-6);
}
