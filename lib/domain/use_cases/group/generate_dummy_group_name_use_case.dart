import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GenerateDummyGroupNameUseCase
    extends ExecUseCase<void, GenerateDummyGroupNameUseCaseParams> {
  final GroupRepo groupRepo;

  GenerateDummyGroupNameUseCase({required this.groupRepo});

  @override
  Future<DomainResponse<void>> exec(
      GenerateDummyGroupNameUseCaseParams params) {
    return groupRepo.generateDummyGroupName(
      groupId: params.groupId,
    );
  }
}

class GenerateDummyGroupNameUseCaseParams {
  final String groupId;

  GenerateDummyGroupNameUseCaseParams({
    required this.groupId,
  });
}
