import 'package:habits_flow/data/sources/habits/habit_local_source.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_error.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HabitRepo)
class HabitRepoImpl extends HabitRepo {
  final HabitLocalSource habitsLocalSource;

  HabitRepoImpl({required this.habitsLocalSource});

  @override
  Future<DomainResponse<HabitEntity>> createHabit({
    required String title,
    required String info,
    required String link,
    required double weight,
    required int groupColor,
  }) async {
    try {
      final habit = await habitsLocalSource.createHabit(
        title: title,
        info: info,
        link: link,
        weight: weight,
        groupColor: groupColor,
      );
      return Success(habit);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Future<DomainResponse<void>> deleteHabit({required String habitId}) {
    // TODO: implement deleteHabit
    throw UnimplementedError();
  }

  @override
  Stream<DomainResponse<HabitEntity>> habitStream({required String habitId}) {
    return habitsLocalSource
        .habitStream(habitId)
        .map((habit) => Success(habit) as DomainResponse<HabitEntity>)
        .handleError(
            (e) => Failure(error: DatabaseError(message: e.toString())));
  }

  @override
  Future<DomainResponse<void>> incHabitCount({required HabitEntity habit}) {
    // TODO: implement incHabitCount
    throw UnimplementedError();
  }

  @override
  Future<DomainResponse<void>> resetHabitCount({required HabitEntity habit}) {
    // TODO: implement resetHabitCount
    throw UnimplementedError();
  }

  @override
  Future<DomainResponse<void>> performHabit({required String habitId}) async {
    try {
      await habitsLocalSource.performHabit(
        habitId: habitId,
        performTime: DateTime.now(),
      );
      return const Success(null);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Future<DomainResponse<void>> resetHabit({required String habitId}) async {
    try {
      await habitsLocalSource.resetHabit(
        habitId: habitId,
      );
      return const Success(null);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Stream<List<HabitEntity>> habitsOfGroupStream(String groupId) {
    return habitsLocalSource.habitsOfGroupStream(groupId);
  }

  @override
  Future<DomainResponse<double>> getNextHabitWeight(String groupId) async {
    try {
      final habits = await habitsOfGroupStream(groupId).first;
      final maxWeight = habits.fold<double>(
          0.0, (max, habit) => habit.weight > max ? habit.weight : max);
      final newWeight = maxWeight + 1.0;
      return Success(newWeight);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Future<void> refresh() {
    return habitsLocalSource.refresh();
  }
}
