import 'package:dio/dio.dart' show DioException;
import 'package:dio_mini/data/user/remote_models/user_remote_model.dart';
import 'package:dio_mini/data/user/remote_source/user_remote_source.dart';
import 'package:dio_mini/logic/entities/result/domain_error.dart';
import 'package:dio_mini/logic/entities/result/domain_response.dart';
import 'package:dio_mini/logic/entities/user_entity.dart';
import 'package:dio_mini/logic/repos/user_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: UserRepo)
class UserRepoImpl implements UserRepo {
  final UserRemoteSource userRemoteSource;

  final Map<int, DomainResponse<UserEntity>> _usersDB = {};

  final _userSubject = BehaviorSubject<Map<int, DomainResponse<UserEntity>>>.seeded({});

  UserRepoImpl({required this.userRemoteSource});

  @override
  Stream<DomainResponse<UserEntity>> userStream({required int id}) {
    return _userSubject.stream.map((usersMap) => usersMap[id]).whereNotNull().distinct();
  }

  @override
  Future<DomainResponse<UserEntity>> getUser({required int id}) async {
    try {
      _userLoading(id);
      final userModel = await _fetchUser(id);
      Success<UserEntity> success = _userSuccess(userModel, id);
      return success;
    } on DioException catch (e) {
      return _userError(id, NetworkError(e.response?.statusCode));
    } catch (e, stackTrace) {

      return _userError(id, UnknownError(e.toString()));
    }
  }

  void _userLoading(int id) {
    var prevEntity = _usersDB[id]?.data;
    _usersDB[id] = Loading(data:prevEntity);
    _updateStream();
  }

  Future<UserRemoteModel> _fetchUser(int id) async => await userRemoteSource.getUser(id: id);

  Success<UserEntity> _userSuccess(UserRemoteModel userModel, int id) {
    final entity = userModel.toEntity();
    final  success = Success(entity);
    _usersDB[id] = success;
    _updateStream();
    return success;
  }

  void _updateStream() => _userSubject.add(Map.unmodifiable(_usersDB));

  Future<DomainResponse<UserEntity>> _userError(int id, DomainError error) async {
    var prevEntity = _usersDB[id]?.data;
    var failure = Failure(data:prevEntity, error: error);
    _usersDB[id] = failure;
    _updateStream();
    return failure;
  }

  void dispose() => _userSubject.close();
}
