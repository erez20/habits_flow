import 'package:fimber/fimber.dart';
import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class PerformHabitUseCase extends ExecUseCase<void, PerformHabitUseCaseParams> {
  PerformHabitUseCase({
    required this.habitRepo,
    required this.groupRepo,
  });

  final HabitRepo habitRepo;
  final GroupRepo groupRepo;

  @override
  Future<DomainResponse<void>> exec(
    PerformHabitUseCaseParams params,
  ) async {
    if (!params.isCompleted) {
      final result = await habitRepo.performHabit(habitId: params.habitId);
      if (result is Success) {
        await habitRepo.refresh();
        await groupRepo.refresh();
      }
      return result;
    } else {
      Fimber.d("habit already completed");
      return Future.value(Success(null));
    }
  }
}

class PerformHabitUseCaseParams {
  final String habitId;
  final bool isCompleted;

  PerformHabitUseCaseParams({
    required this.habitId,
    required this.isCompleted,
  });
}
