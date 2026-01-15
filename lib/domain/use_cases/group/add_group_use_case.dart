import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/get_use_case.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AddGroupUseCase extends GetUseCase<GroupEntity, AddGroupUseCaseParams> {
  final GroupRepo groupRepo;

  AddGroupUseCase({required this.groupRepo});

  @override
  Future<DomainResponse<GroupEntity>> exec(AddGroupUseCaseParams params) {
    return groupRepo.createGroup(
      title: params.title,
      weight: params.weight,
      colorHex: params.colorHex,
    );
  }
}

class AddGroupUseCaseParams {
  final String title;
  final int weight;
  final String colorHex;

  AddGroupUseCaseParams({
    required this.title,
    required this.weight,
    required this.colorHex,
  });
}
