import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:fimber/fimber.dart' show Fimber;
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Habits extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get info => text().withDefault(const Constant(''))();

  TextColumn get link => text().withDefault(const Constant(''))();

  RealColumn get weight => real().withDefault(const Constant(1.0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Foreign key to Groups table
  TextColumn get groupId =>
      text().nullable().references(Groups, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}

class Groups extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  IntColumn get weight => integer().withDefault(const Constant(0))();

  IntColumn get colorValue => integer()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  IntColumn get durationInSec => integer().withDefault(const Constant(86400))();

  @override
  Set<Column> get primaryKey => {id};
}

class HabitPerformances extends Table {
  TextColumn get id => text()();

  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get performTime =>
      dateTime()(); // Specific time of performance
  IntColumn get timeKey => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@singleton
@DriftDatabase(tables: [Habits, Groups, HabitPerformances])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 5) {
        await m.addColumn(habitPerformances, habitPerformances.timeKey);
      }
    },
  );

  Stream<int> watchHabitCompletionCount(String habitId, int durationInSec) {
    final timeKey =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000) ~/ durationInSec;

    final countExpression = habitPerformances.id.count();

    return (selectOnly(habitPerformances)
          ..addColumns([countExpression])
          ..where(
            habitPerformances.habitId.equals(habitId) &
                habitPerformances.timeKey.equals(timeKey),
          ))
        .map((row) => row.read(countExpression) ?? 0)
        .watchSingle();
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'habits_flow_db');
  }

  Future<File> _getDbFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return File(p.join(dbFolder.path, 'habits_flow_db.sqlite'));
  }

  //import / export
  Future<File> _getBackupFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    var timestamp =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}";

    return File(p.join(dbFolder.path, 'habits_$timestamp.sqlite'));
  }

  Future<File> generateBackup() async {
    await customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
    final dbFile = await _getDbFile();
    final backupFile = await _getBackupFile();
    await dbFile.copy(backupFile.path);

    Fimber.i('Backup generated at ${backupFile.path}');
    return backupFile;
  }

  Future<void> restoreBackup(String pickedFilePath) async {
    await close();
    //Overwrite the db file
    final dbFile = await _getDbFile();
    await File(pickedFilePath).copy(dbFile.path);

    //TODO  3. Restart the app (or reinitialize the DB singleton)
  }
}
