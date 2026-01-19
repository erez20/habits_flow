import 'package:habits_flow/domain/entities/habit_entity.dart';

abstract class HabitLocalSource {
  Future<HabitEntity> createHabit({
    required String title,
    required int weight,
  });

  Future<void> deleteHabit({required String habitId}) ;

  Future<void> performHabit({
    required String habitId,
    required DateTime performTime,
  });

  Future<void> deleteHabitPerformance({
    required String habitId,
    required DateTime performTime, // To identify the performance to delete (or use ID if passed)
  });

  Future<int> getHabitCompletionCount({
    required String habitId,
    required DateTime date,
  });
}