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
    required int weight,
  }) async {
    try {
      final habit = await habitsLocalSource.createHabit(
        title: title,
        weight: weight,
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
  Stream<DomainResponse<HabitEntity>> habitStream({required int id}) {
    // TODO: implement habitStream
    throw UnimplementedError();
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
}
