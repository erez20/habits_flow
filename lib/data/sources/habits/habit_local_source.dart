import 'package:habits_flow/domain/entities/habit_entity.dart';

abstract class HabitLocalSource {
  Future<HabitEntity> createHabit({
    required String title,
    required int weight,
  });

  Future<void> deleteHabit({required String habitId}) ;
}