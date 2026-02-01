import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetHabitUseCase extends ExecUseCase<void, ResetHabitUseCaseParams> {
  ResetHabitUseCase({
    required this.habitRepo,
  });

  final HabitRepo habitRepo;

  @override
  Future<DomainResponse<void>> exec(
    ResetHabitUseCaseParams params,
  ) {
    return habitRepo.resetHabit(habitId: params.habitId);
  }
}

class ResetHabitUseCaseParams {
  final String habitId;

  ResetHabitUseCaseParams({required this.habitId});
}
