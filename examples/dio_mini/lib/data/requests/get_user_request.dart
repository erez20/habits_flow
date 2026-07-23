import 'package:dio_mini/data/network/requests/get_request.dart';

class GetUserRequest extends GetRequest {
  final int id;

  GetUserRequest({
    required this.id,
    required super.dio,
  });

  Future<Map<String, dynamic>> exec() async {
    final x =  await dio.get('/user/$id');
    return x.data;
  }
}
