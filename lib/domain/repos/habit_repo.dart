import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';

abstract class HabitsRepo {
  Stream<DomainResponse<HabitEntity>> habitStream({required int id});

  Future<DomainResponse<HabitEntity>> createHabit({
    required String title,
    required int weight,
  });

  Future<DomainResponse<void>> deleteHabit({
    required String habitId,
  });

  Future<DomainResponse<void>> incHabitCount({
    required HabitEntity habit,
  });

  Future<DomainResponse<void>> resetHabitCount({
    required HabitEntity habit,
  });


}
