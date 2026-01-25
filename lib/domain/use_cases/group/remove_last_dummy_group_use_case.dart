import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveLastDummyGroupUseCase extends ExecUseCase<void, void> {
  RemoveLastDummyGroupUseCase({required this.repo});

  final GroupRepo repo;


  @override
  Future<DomainResponse<void>> exec(void params) {
    return repo.removeLastDummy();
  }
}
