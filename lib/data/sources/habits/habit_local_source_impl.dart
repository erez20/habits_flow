import 'package:drift/drift.dart';
import 'package:habits_flow/data/db/database.dart';
import 'package:habits_flow/data/sources/habits/habit_local_source.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

@Injectable(as: HabitLocalSource)
class HabitLocalSourceImpl implements HabitLocalSource {
  final AppDatabase db;

  HabitLocalSourceImpl(this.db);

  @override
        Future<HabitEntity> createHabit({
          required String title,
          required String info,
          required String link,
          required double weight,
          required int groupColor,
        }) async {
          final id = const Uuid().v4();
          final companion = HabitsCompanion.insert(
            id: id,
            title: title,
            info: Value(info),
            link: Value(link),
            weight: Value(weight),
            createdAt: Value(DateTime.now()),
          );
      
          await db.into(db.habits).insert(companion);
      
          return HabitEntity(
            id: id,
            title: title,
            info: info,
            link: link,
            weight: weight,
            completionCount: 0, //new habit
            groupColor: groupColor,
          );
        }  @override
  Future<void> deleteHabit({required String habitId}) async {
    await (db.delete(db.habits)..where((tbl) => tbl.id.equals(habitId))).go();
  }

  @override
  Future<int> getHabitCompletionCount({
    required String habitId,
    required DateTime date,
  }) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final dailyPerformances = await (db.select(db.habitPerformances)
          ..where((t) =>
              t.habitId.equals(habitId) &
              t.performTime.isBetween(Variable(start), Variable(end))))
        .get();

    return dailyPerformances.length;
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
  Future<void> resetHabit({
    required String habitId,

  }) async {
    await (db.delete(db.habitPerformances)
          ..where((tbl) => tbl.habitId.equals(habitId)))
        .go();
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

  @override
  Stream<List<HabitEntity>> habitsOfGroupStream(String groupId) {
    final query = db.select(db.habits).join([
      innerJoin(db.groups, db.groups.id.equalsExp(db.habits.groupId)),
    ])..where(db.habits.groupId.equals(groupId));

    return query.watch().switchMap((rows) {
      if (rows.isEmpty) {
        return Stream.value([]);
      }
      final habitEntities = rows.map((row) {
        final habit = row.readTable(db.habits);
        final group = row.readTable(db.groups);
        return (habit: habit, groupColor: group.colorValue);
      }).toList();

      final completionCountStreams = habitEntities.map((h) =>
          db.watchHabitDailyCompletionCount(h.habit.id, DateTime.now()));

      return Rx.combineLatestList(completionCountStreams).map((counts) {
        return List.generate(habitEntities.length, (index) {
          final h = habitEntities[index];
          return HabitEntity(
            id: h.habit.id,
            title: h.habit.title,
            weight: h.habit.weight,
            info: h.habit.info,
            link: h.habit.link,
            completionCount: counts[index],
            groupColor: h.groupColor,
          );
        });
      });
    });
  }

  @override
    Stream<HabitEntity> habitStream(String habitId) {
      final habitWithGroupStream = (db.select(db.habits).join([
        innerJoin(db.groups, db.groups.id.equalsExp(db.habits.groupId)),
      ])..where(db.habits.id.equals(habitId)))
          .watchSingle();
  
      final performancesStream = (db.select(db.habitPerformances)
            ..where((tbl) => tbl.habitId.equals(habitId)))
          .watch();
  
          return Rx.combineLatest2<TypedResult, int, HabitEntity>(
              habitWithGroupStream,
              db.watchHabitDailyCompletionCount(habitId, DateTime.now()),
              (TypedResult row, int completionCount) {
            final habit = row.readTable(db.habits);
            final group = row.readTable(db.groups);
            return HabitEntity(
              id: habit.id,
              title: habit.title,
              weight: habit.weight,
              info: habit.info,
              link: habit.link,
              completionCount: completionCount,
              groupColor: group.colorValue,
            );
          });
    }

  @override
  Stream<int> watchHabitDailyCompletionCount(String habitId, DateTime date) {
    return db.watchHabitDailyCompletionCount(habitId, date);
  }
}
