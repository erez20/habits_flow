import 'dart:io';

import 'package:habits_flow/data/sources/backup/backup_local_source.dart';
import 'package:habits_flow/domain/repos/backup_repo.dart';
import 'package:habits_flow/domain/responses/domain_error.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BackupRepo)
class BackupRepoImpl extends BackupRepo {
  final BackupLocalSource backupLocalSource;

  BackupRepoImpl({
    required this.backupLocalSource,
  });

  @override
  Future<DomainResponse<File>> generateBackup() async{
    try {
      final file = await backupLocalSource.generateBackup();
      return Success(file);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Future<DomainResponse<void>> restoreBackup(String pickedFilePath) async {
    try {
      await backupLocalSource.restoreBackup(pickedFilePath);
      return Success(null);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }





}