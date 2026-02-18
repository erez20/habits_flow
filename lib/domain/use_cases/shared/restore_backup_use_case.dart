import 'package:habits_flow/domain/repos/backup_repo.dart';
import 'package:habits_flow/domain/responses/domain_error.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart' show Injectable;

@Injectable()
class RestoreBackupUseCase extends ExecUseCase<void, String> {
  final BackupRepo backupRepo;
  RestoreBackupUseCase({required this.backupRepo});

  @override
  Future<DomainResponse<void>> exec(String path) async {
    try {
      await backupRepo.restoreBackup(path);
      return Success(null);
    } catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }
}
