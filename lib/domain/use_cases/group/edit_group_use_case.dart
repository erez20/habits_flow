import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/responses/domain_error.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditGroupUseCase extends ExecUseCase<void, GroupEntity>{
  final GroupRepo repo;

  EditGroupUseCase({required this.repo});

  @override
  Future<DomainResponse<void>> exec(GroupEntity group) async {
    try {
      await repo.updateGroup(group);
      return Success(null);
    } catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }
}