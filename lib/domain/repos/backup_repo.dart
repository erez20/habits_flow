import 'dart:io';

import 'package:habits_flow/domain/responses/domain_response.dart';

abstract class BackupRepo {
  Future<DomainResponse<File>> generateBackup();

  Future<DomainResponse<void>> restoreBackup(String pickedFilePath);
}
