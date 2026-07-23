

import 'package:dio/dio.dart';
import 'package:dio_mini/data/requests/get_user_request.dart';
import 'package:dio_mini/data/user/remote_models/user_remote_model.dart';
import 'package:injectable/injectable.dart' show Injectable;

@Injectable()
class UserRemoteSource {
  final Dio _dio;

  UserRemoteSource({required Dio dio}) : _dio = dio;

  Future<UserRemoteModel> getUser({
    required int id,
  }) async {
    final request = GetUserRequest(dio: _dio, id: id);
    final data = await request.exec();
    var userRemoteModel = UserRemoteModel.fromJson(data);
    return userRemoteModel;
  }
}
