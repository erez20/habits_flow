import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReorderGroupsUseCase extends ExecUseCase<void, List<GroupEntity>> {
  final GroupRepo _repo;

  ReorderGroupsUseCase(this._repo);

  @override
  Future<DomainResponse<void>> exec(List<GroupEntity> params) {
    return _repo.reorder(params);
  }
}
