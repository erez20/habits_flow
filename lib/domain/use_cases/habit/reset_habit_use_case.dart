import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetHabitUseCase extends ExecUseCase<void, ResetHabitUseCaseParams> {
  ResetHabitUseCase({
    required this.habitRepo,
    required this.groupRepo,
  });

  final HabitRepo habitRepo;
  final GroupRepo groupRepo;

  @override
  Future<DomainResponse<void>> exec(
    ResetHabitUseCaseParams params,
  ) async {
    final result = await habitRepo.resetHabit(habitId: params.habitId);
    if (result is Success) {
      await habitRepo.refresh();
      await groupRepo.refresh();
    }
    return result;
  }
}

class ResetHabitUseCaseParams {
  final String habitId;

  ResetHabitUseCaseParams({required this.habitId});
}
