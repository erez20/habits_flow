import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditHabitUseCase extends ExecUseCase<void, HabitEntity> {
  final HabitRepo habitRepo;


  EditHabitUseCase({
    required this.habitRepo,
  });

  @override
  Future<DomainResponse<void>> exec(HabitEntity habit) async {
    final result = await habitRepo.updateHabit(habit: habit);
    return result;
  }
}
