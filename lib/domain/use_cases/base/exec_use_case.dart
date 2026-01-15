
import 'package:habits_flow/domain/responses/domain_response.dart';

abstract class ExecUseCase<T,Params> {
  Future<DomainResponse<T>> exec(Params params);
}