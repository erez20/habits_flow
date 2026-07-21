import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/use_cases/base/stream_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class HabitsOfGroupStreamUseCase extends StreamUseCase<List<HabitEntity>, String> {
  final HabitRepo habitRepo;

  HabitsOfGroupStreamUseCase({required this.habitRepo});

  @override
  Stream<List<HabitEntity>> stream(String groupId) => habitRepo.habitsOfGroupStream(groupId);
}
