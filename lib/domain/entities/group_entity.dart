import 'package:equatable/equatable.dart';
import 'habit_entity.dart';

class GroupEntity extends Equatable {
  final String id;
  final String title;
  final int weight;
  final List<HabitEntity> habits;
  final String colorHex;

  const GroupEntity({
    required this.id,
    required this.title,
    required this.weight,
    required this.habits,
    required this.colorHex,
  });

  @override
  List<Object?> get props => [id, title, weight, habits, colorHex];

  void addHabit(HabitEntity habit) {
    habits.add(habit);
  }

  void removeHabit(HabitEntity habit) {
    habits.remove(habit);
  }

  @override
  String toString() {
    return 'GroupEntity(id: ${id.substring(id.length - 6)}, title: $title)';
  }
}
