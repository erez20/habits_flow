import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteHabitUseCase extends ExecUseCase<void, String> {
  final HabitRepo habitRepo;

  DeleteHabitUseCase({required this.habitRepo});

  @override
  Future<DomainResponse<void>> exec(String habitId) =>
      habitRepo.deleteHabit(habitId:  habitId);
}
