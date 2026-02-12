import 'package:fimber/fimber.dart';
import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/repos/refresh_scheduler_repo.dart';
import 'package:habits_flow/domain/responses/domain_error.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class RefreshAllUseCase extends ExecUseCase<void, void> {
  final GroupRepo groupRepo;
  final HabitRepo habitRepo;
  final RefreshSchedulerRepo refreshSchedulerRepo;

  RefreshAllUseCase({
    required this.groupRepo,
    required this.habitRepo,
    required this.refreshSchedulerRepo,
  });

  @override
  Future<DomainResponse<void>> exec(void params) async {
    try {
      refreshSchedulerRepo.refreshStream.skip(1).listen((onData) async =>
      await Future.wait([
        groupRepo.refresh(),
        habitRepo.refresh(),
      ]));
      Fimber.e("this is the first refresh");
      return const Success(null);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }
}
