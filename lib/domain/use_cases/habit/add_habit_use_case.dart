import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddHabitUseCase extends ExecUseCase<void, AddHabitUseCaseParams> {
  final HabitRepo habitRepo;
  final GroupRepo groupRepo;

  AddHabitUseCase({
    required this.habitRepo,
    required this.groupRepo,
  });

  @override
  Future<DomainResponse<void>> exec(AddHabitUseCaseParams params) async {
    final habitResp = await habitRepo.createHabit(
      title: params.title,
      weight: params.weight,
    );

    if (habitResp case Failure(:final error)) {
      return Failure(error: error);
    }

    final habit = habitResp.data!;

    final groupResp = await groupRepo.addHabitToGroup(
      groupId: params.groupId,
      habit: habit,
    );

    if (groupResp case Failure(:final error)) {
      return Failure(error: error);
    }

    return const Success(null);
  }
}

class AddHabitUseCaseParams {
  final String groupId;
  final String title;
  final int weight;
  final String info;

  AddHabitUseCaseParams({
    required this.groupId,
    required this.title,
    required this.weight,
    required this.info,
  });
}
