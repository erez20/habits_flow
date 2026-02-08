import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';

part 'database.g.dart';

class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get info => text().withDefault(const Constant(''))();
  TextColumn get link => text().withDefault(const Constant(''))();
  RealColumn get weight => real().withDefault(const Constant(1.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Foreign key to Groups table
  TextColumn get groupId => text().nullable().references(Groups, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}

class Groups extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get weight => integer().withDefault(const Constant(0))();
  IntColumn get colorValue => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get duration => integer().withDefault(const Constant(24))();

  @override
  Set<Column> get primaryKey => {id};
}

class HabitPerformances extends Table {
  TextColumn get id => text()();
  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get performTime => dateTime()(); // Specific time of performance

  @override
  Set<Column> get primaryKey => {id};
}

@singleton
@DriftDatabase(tables: [Habits, Groups, HabitPerformances])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());


  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from == 1) {
        await m.addColumn(habits, habits.link);
      }
      if (from == 2) {
        await m.addColumn(groups, groups.duration);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'habits_flow_db');
  }
}
