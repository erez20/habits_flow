import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';

abstract class HabitRepo {
  Stream<DomainResponse<HabitEntity>> habitStream({required String habitId});

  Future<DomainResponse<HabitEntity>> createHabit({
    required String title,
    required String info,
    required String link,
    required double weight,
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

  Stream<List<HabitEntity>> habitsOfGroupStream(String groupId);

  Future<DomainResponse<double>> getNextHabitWeight(String groupId);
}
