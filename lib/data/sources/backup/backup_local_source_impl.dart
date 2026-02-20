import 'dart:io';

import 'package:habits_flow/data/db/database.dart';
import 'package:injectable/injectable.dart';

import 'backup_local_source.dart';

@Injectable(as: BackupLocalSource)
class BackupLocalSourceImpl extends BackupLocalSource{
  final  AppDatabase db;
  BackupLocalSourceImpl(this.db);

  @override
  Future<File> generateBackup() => db.generateBackup();

  @override
  Future<void> restoreBackup(String pickedFilePath) => db.restoreBackup(pickedFilePath);
}