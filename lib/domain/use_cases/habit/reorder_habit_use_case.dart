import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReorderHabitUseCase extends ExecUseCase<void, ReorderHabitUseCaseParams> {
  final HabitRepo _repo;

  ReorderHabitUseCase({required HabitRepo repo}) : _repo = repo;

  @override
  Future<DomainResponse<void>> exec(ReorderHabitUseCaseParams params) {
    return _repo.reorderHabit(
      habitId: params.habitId,
      steps: params.steps,
    );
  }
}

class ReorderHabitUseCaseParams {
  final String habitId;
  final int steps;

  ReorderHabitUseCaseParams({
    required this.habitId,
    required this.steps,
  });
}
