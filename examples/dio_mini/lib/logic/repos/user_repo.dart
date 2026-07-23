import 'package:dio_mini/logic/entities/result/domain_response.dart' show DomainResponse;
import 'package:dio_mini/logic/entities/user_entity.dart';

abstract class UserRepo {
  Future<DomainResponse<UserEntity>> getUser({
    required int id,
  });

  Stream<DomainResponse<UserEntity>> userStream({required int id});
}
