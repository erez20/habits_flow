import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:habits_flow/domain/use_cases/base/stream_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class ListenGroupIdsListUseCase extends StreamUseCase<List<String>> {
  final GroupRepo groupRepo;

  ListenGroupIdsListUseCase({required this.groupRepo});
  
  @override 
  Stream<List<String>> get stream => groupRepo.getGroupIdsListStream() ;
  
}