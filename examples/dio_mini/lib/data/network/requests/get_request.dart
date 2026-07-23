import 'package:dio/dio.dart' show Dio;

abstract class GetRequest {
  final Dio dio;

  const GetRequest({
    required this.dio,
  });
}