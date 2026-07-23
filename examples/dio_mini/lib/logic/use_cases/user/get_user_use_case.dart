import 'package:dio_mini/logic/entities/result/domain_response.dart';
import 'package:dio_mini/logic/entities/user_entity.dart';
import 'package:dio_mini/logic/repos/user_repo.dart';
import 'package:dio_mini/logic/use_cases/base/get_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserUseCase extends GetUseCase<UserEntity, int> {
  final UserRepo userRepo;
  GetUserUseCase({

    required this.userRepo,
  });

  @override
  Future<DomainResponse<UserEntity>> exec(int id) => userRepo.getUser(id: id);
}
