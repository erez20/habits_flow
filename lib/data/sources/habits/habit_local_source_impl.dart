import 'package:drift/drift.dart';
import 'package:habits_flow/data/db/database.dart';
import 'package:habits_flow/data/sources/habits/habit_local_source.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: HabitLocalSource)
class HabitLocalSourceImpl implements HabitLocalSource {
  final AppDatabase db;

  HabitLocalSourceImpl(this.db);

  @override
  Future<HabitEntity> createHabit({
    required String title,
    required int weight,
  }) async {
    final id = const Uuid().v4();
    final companion = HabitsCompanion.insert(
      id: id,
      title: title,
      weight: Value(weight),
      createdAt: Value(DateTime.now()),
    );

    await db.into(db.habits).insert(companion);

    return HabitEntity(
      id: id,
      title: title,
      weight: weight,
      info: '',
      completionCount: 0,
    );
  }

  @override
  Future<void> deleteHabit({required String habitId}) async {
    await (db.delete(db.habits)..where((tbl) => tbl.id.equals(habitId))).go();
  }

  @override
  Future<int> getHabitCompletionCount({
    required String habitId,
    required DateTime date,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final countExpression = db.habitPerformances.id.count();
    final query = db.selectOnly(db.habitPerformances)
      ..addColumns([countExpression])
      ..where(db.habitPerformances.habitId.equals(habitId) &
          db.habitPerformances.performTime
              .isBetween(Variable(startOfDay), Variable(endOfDay)));

    final result =
        await query.map((row) => row.read(countExpression)).getSingle();
    return result ?? 0;
  }

  @override
  Future<void> performHabit({
    required String habitId,
    required DateTime performTime,
  }) async {
    final id = const Uuid().v4();
    final companion = HabitPerformancesCompanion.insert(
      id: id,
      habitId: habitId,
      performTime: performTime,
    );
    await db.into(db.habitPerformances).insert(companion);
  }

  @override
  Future<void> deleteHabitPerformance({
    required String habitId,
    required DateTime performTime,
  }) async {
    final startOfDay =
        DateTime(performTime.year, performTime.month, performTime.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final lastPerformance = await (db.select(db.habitPerformances)
          ..where((tbl) => tbl.habitId.equals(habitId) &
              tbl.performTime
                  .isBetween(Variable(startOfDay), Variable(endOfDay)))
          ..orderBy([
            (t) => OrderingTerm(expression: t.performTime, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingleOrNull();

    if (lastPerformance != null) {
      await (db.delete(db.habitPerformances)
            ..where((tbl) => tbl.id.equals(lastPerformance.id)))
          .go();
    }
  }
}
