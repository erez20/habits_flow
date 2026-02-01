import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class PerformHabitUseCase extends ExecUseCase<void, PerformHabitUseCaseParams> {
  PerformHabitUseCase({
    required this.habitRepo,
  });

  final HabitRepo habitRepo;

  @override
  Future<DomainResponse<void>> exec(
    PerformHabitUseCaseParams params,
  ) {
    return habitRepo.performHabit(habitId: params.habitId);
  }
}

class PerformHabitUseCaseParams {
  final String habitId;

  PerformHabitUseCaseParams({required this.habitId});
}
