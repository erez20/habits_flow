import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteHabitUseCase extends ExecUseCase<void, String> {
  final HabitRepo habitRepo;
  final GroupRepo groupRepo;

  DeleteHabitUseCase({
    required this.habitRepo,
    required this.groupRepo,
  });

  @override
  Future<DomainResponse<void>> exec(String habitId) async {
    final result = await habitRepo.deleteHabit(habitId: habitId);
    if (result is Success) {
      await habitRepo.refresh();
      await groupRepo.refresh();
    }
    return result;
  }
}
