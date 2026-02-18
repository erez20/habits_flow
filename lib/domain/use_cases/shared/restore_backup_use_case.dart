import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart' show Injectable;

@Injectable()
class RestoreBackupUseCase extends ExecUseCase<void, String> {
  @override
  Future<DomainResponse<void>> exec(String path) {

  }
}
