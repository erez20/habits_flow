import 'dart:io';

abstract class BackupLocalSource {
  Future<File> generateBackup();
  Future<void> restoreBackup(String pickedFilePath);
}