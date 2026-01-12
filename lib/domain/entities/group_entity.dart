import 'habit_entity.dart';

class GroupEntity {
  final String id;
  final String title;
  final int weight;
  final List<HabitEntity> habits;
  final String colorHex;

  GroupEntity({
    required this.id,
    required this.title,
    required this.weight,
    required this.habits,
    required this.colorHex,
  });
}
