import 'dart:io';

import 'package:habits_flow/domain/repos/backup_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/base/exec_use_case.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GenerateBackupUseCase extends ExecUseCase<File, void> {
  final BackupRepo backupRepo;

  GenerateBackupUseCase({required this.backupRepo});

  @override
  Future<DomainResponse<File>> exec(void params) async {
    return await backupRepo.generateBackup();
  }
}