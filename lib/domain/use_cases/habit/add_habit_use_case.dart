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
    final weightResp = await habitRepo.getNextHabitWeight(params.groupId);

    if (weightResp case Failure(:final error)) {
      return Failure(error: error);
    }
    final newWeight = weightResp.data!;

    final habitResp = await habitRepo.createHabit(
      title: params.title,
      info: params.info,
      link: params.link,
      weight: newWeight,
      groupColor: params.groupColor,
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
  final String info;
  final String link;
  final int groupColor;


  AddHabitUseCaseParams({
    required this.groupId,
    required this.title,
    required this.info,
    required this.link,
    required this.groupColor,
  });
}
