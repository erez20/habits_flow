
import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddHabitUseCase extends ExecUseCase<void,AddHabitUseCaseParams>{

  final AddHabitUseCase addHabitUseCase;
  final AddHabitToGroupUseCase addHabitToGroupUseCase;


  AddHabitUseCase({
    required this.addHabitUseCase,
  });

  @override
  Future<DomainResponse<void>> exec(AddHabitUseCaseParams params) async{
    try {
      final habitResp = await addHabitUseCase.exec(AddHabitUseCaseParams(groupId: params.groupId, title: params.title, weight: params.weight, info: ''));
      if (habitResp is Failure) return Failure(error: habitResp.error);
      final habit = habitResp.data;
      final group = await

    }


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

}