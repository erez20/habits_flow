import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_error.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class RefreshAllUseCase extends ExecUseCase<void, void> {
  final GroupRepo _groupRepo;
  final HabitRepo _habitRepo;

  RefreshAllUseCase(this._groupRepo, this._habitRepo);

  @override
  Future<DomainResponse<void>> exec(void params) async {
    try {
      await Future.wait([
        _groupRepo.refresh(),
        _habitRepo.refresh(),
      ]);
      return const Success(null);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }
}
