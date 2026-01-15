import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteGroupUseCase extends ExecUseCase<void, String> {
  final GroupRepo groupRepo;

  DeleteGroupUseCase({required this.groupRepo});

  @override
  Future<DomainResponse<void>> exec(String groupId) =>
      groupRepo.deleteGroup(groupId: groupId);
}
