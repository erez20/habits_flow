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
  final _refreshController = BehaviorSubject<void>();

  HabitLocalSourceImpl(this.db);

  @override
  Future<void> refresh() async {
    _refreshController.add(null);
  }

  @override
  Future<HabitEntity> createHabit({
    required String title,
    required String info,
    required String link,
    required double weight,
    required int groupColor,
    required int points,
  }) async {
    final id = const Uuid().v4();
    final companion = HabitsCompanion.insert(
      id: id,
      title: title,
      info: Value(info),
      link: Value(link),
      weight: Value(weight),
      createdAt: Value(DateTime.now()),
      points: Value(points),
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
      points: points,
    );
  }

  @override
  Future<void> updateHabit({required HabitEntity habit}) async {
    await (db.update(db.habits)..where((tbl) => tbl.id.equals(habit.id)))
        .write(HabitsCompanion(
      title: Value(habit.title),
      info: Value(habit.info),
      link: Value(habit.link),
      points: Value(habit.points),
    ));
  }

  @override
  Future<void> deleteHabit({required String habitId}) async {
    await (db.delete(db.habits)..where((tbl) => tbl.id.equals(habitId))).go();
  }

  @override
  Future<int> getHabitCompletionCount({
    required String habitId,
  }) async {
    final habit = await (db.select(db.habits)
          ..where((tbl) => tbl.id.equals(habitId)))
        .getSingle();

    if (habit.groupId == null) {
      throw Exception('Habit with ID $habitId has no group.');
    }

    final group = await (db.select(db.groups)
          ..where((tbl) => tbl.id.equals(habit.groupId!)))
        .getSingle();
    final timeKey = (DateTime.now().millisecondsSinceEpoch ~/ 1000) ~/
        group.durationInSec;

    final performances = await (db.select(db.habitPerformances)
          ..where((t) =>
              t.habitId.equals(habitId) & t.timeKey.equals(timeKey)))
        .get();

    return performances.length;
  }

  @override
  Future<void> performHabit({
    required String habitId,
    required DateTime performTime,
  }) async {
    final habit = await (db.select(db.habits)
          ..where((tbl) => tbl.id.equals(habitId)))
        .getSingle();

    if (habit.groupId == null) {
      throw Exception('Habit with ID $habitId has no group.');
    }
    final group = await (db.select(db.groups)
          ..where((tbl) => tbl.id.equals(habit.groupId!)))
        .getSingle();

    final timeKey =
        (performTime.millisecondsSinceEpoch ~/ 1000) ~/ group.durationInSec;

    final id = const Uuid().v4();
    final companion = HabitPerformancesCompanion.insert(
      id: id,
      habitId: habitId,
      performTime: performTime,
      timeKey: Value(timeKey),
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
    final habit = await (db.select(db.habits)
          ..where((tbl) => tbl.id.equals(habitId)))
        .getSingle();
    if (habit.groupId == null) {
      throw Exception('Habit with ID $habitId has no group.');
    }
    final group = await (db.select(db.groups)
          ..where((tbl) => tbl.id.equals(habit.groupId!)))
        .getSingle();
    final timeKey =
        (performTime.millisecondsSinceEpoch ~/ 1000) ~/ group.durationInSec;

    final lastPerformance = await (db.select(db.habitPerformances)
          ..where((tbl) =>
              tbl.habitId.equals(habitId) & tbl.timeKey.equals(timeKey))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.performTime, mode: OrderingMode.desc)
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
    return _refreshController.startWith(null).switchMap((_) {
      final nowInSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final countQuery = subqueryExpression<int>(
        db.selectOnly(db.habitPerformances)
          ..addColumns([db.habitPerformances.id.count()])
          ..where(db.habitPerformances.habitId.equalsExp(db.habits.id) &
              db.habitPerformances.timeKey.equalsExp(
                  Variable(nowInSec) / db.groups.durationInSec))
      );

      final query = db.select(db.habits).join([
        innerJoin(db.groups, db.groups.id.equalsExp(db.habits.groupId)),
      ])
        ..where(db.habits.groupId.equals(groupId))
        ..orderBy([
          OrderingTerm(expression: db.habits.weight, mode: OrderingMode.asc),
        ]);

      query.addColumns([countQuery]);

      return query.watch().map((rows) {
        return rows.map((row) {
          final habit = row.readTable(db.habits);
          final group = row.readTable(db.groups);
          final completionCount = row.read(countQuery) ?? 0;

          return HabitEntity(
            id: habit.id,
            title: habit.title,
            weight: habit.weight,
            info: habit.info,
            link: habit.link,
            completionCount: completionCount,
            groupColor: group.colorValue,
            points: habit.points,
          );
        }).toList();
      });
    });
  }

  @override
  Stream<HabitEntity> habitStream(String habitId) {
    final habitWithGroupStream = (db.select(db.habits).join([
      innerJoin(db.groups, db.groups.id.equalsExp(db.habits.groupId)),
    ])..where(db.habits.id.equals(habitId)))
        .watchSingle();

    return Rx.combineLatest2(
      habitWithGroupStream,
      _refreshController.startWith(null),
      (row, _) => row,
    ).switchMap((row) {
      final habit = row.readTable(db.habits);
      final group = row.readTable(db.groups);

      return db
          .watchHabitCompletionCount(habitId, group.durationInSec)
          .map((completionCount) {
        return HabitEntity(
          id: habit.id,
          title: habit.title,
          weight: habit.weight,
          info: habit.info,
          link: habit.link,
          completionCount: completionCount,
          groupColor: group.colorValue,
          points: habit.points,
        );
      });
    });
  }

  @override
  Stream<int> watchHabitCompletionCount(String habitId, int durationInSec) {
    return db.watchHabitCompletionCount(habitId, durationInSec);
  }

  @override
  Future<void> reorderHabit(
      {required String habitId, required int steps}) async {
    final habit =
        await (db.select(db.habits)..where((tbl) => tbl.id.equals(habitId)))
            .getSingle();
    final groupId = habit.groupId;
    if (groupId == null) {
      throw Exception('Habit has no group');
    }

    final habits = await (db.select(db.habits)
          ..where((tbl) => tbl.groupId.equals(groupId))
          ..orderBy([(t) =>
            OrderingTerm(expression: t.weight, mode: OrderingMode.asc)
          ]))
        .get();
    final currentPosition = habits.indexWhere((h) => h.id == habitId);

    final newWeight = _calculateNewWeight(habits, currentPosition, steps);

    await (db.update(db.habits)..where((tbl) => tbl.id.equals(habitId)))
        .write(HabitsCompanion(weight: Value(newWeight)));
  }

  double _calculateNewWeight(List<Habit> habits, int currentPosition, int steps) {
    if (habits.isEmpty) {
      return 1.0;
    }
    final newPosition = currentPosition + steps;
    if (newPosition <= 0) {
      // Move to the beginning
      return habits.first.weight / 2;
    } else if (newPosition >= habits.length - 1) {
      // Move to the end
      return habits.last.weight + 1;
    } else {
      // Move in between
      if (steps < 0) { // Moving up
        final prevWeight = habits[newPosition - 1].weight;
        final nextWeight = habits[newPosition].weight;
        return (prevWeight + nextWeight) / 2;
      } else { // Moving down
        final prevWeight = habits[newPosition].weight;
        final nextWeight = habits[newPosition + 1].weight;
        return (prevWeight + nextWeight) / 2;
      }
    }
  }
}
