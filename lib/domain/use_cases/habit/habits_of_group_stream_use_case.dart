import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/use_cases/base/stream_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class HabitsOfGroupStreamUseCase extends StreamUseCase<List<HabitEntity>, String> {
  final HabitRepo _repo;

  HabitsOfGroupStreamUseCase(this._repo);

  @override
  Stream<List<HabitEntity>> stream(String groupId) => _repo.habitsOfGroupStream(groupId);
}
