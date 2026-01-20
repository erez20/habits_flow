import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/use_cases/base/stream_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class GroupsListStreamUseCase extends StreamUseCase<List<GroupEntity>> {
  final GroupRepo groupRepo;

  GroupsListStreamUseCase({required this.groupRepo});

  @override
  Stream<List<GroupEntity>> get stream => groupRepo.getGroupsListStream();
}