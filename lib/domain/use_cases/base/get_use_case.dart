import 'package:dio_mini/logic/entities/result/domain_response.dart';

abstract class GetUseCase<T,Params> {
  Future<DomainResponse<T>> exec(Params params);
}