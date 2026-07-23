import 'package:dio_mini/logic/entities/result/domain_response.dart' show DomainResponse;
import 'package:dio_mini/logic/entities/user_entity.dart';
import 'package:dio_mini/logic/repos/user_repo.dart';
import 'package:dio_mini/logic/use_cases/base/stream_use_case.dart'
    show StreamUseCase;

class StreamUserUseCase extends StreamUseCase<DomainResponse<UserEntity>> {
  final UserRepo userRepo;
  final int id;

  StreamUserUseCase({
    required this.userRepo,
    required this.id,
  });

  @override
  Stream<DomainResponse<UserEntity>> get listen => userRepo.userStream(id: id);
}
