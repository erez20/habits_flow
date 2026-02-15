import 'package:drift/drift.dart';
import 'package:habits_flow/data/db/database.dart';
import 'package:habits_flow/data/sources/groups/group_local_source.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

@Injectable(as: GroupLocalSource)
class GroupLocalSourceImpl implements GroupLocalSource {
  final AppDatabase db;
  final _refreshController = BehaviorSubject<void>();

  GroupLocalSourceImpl(this.db);

  @override
  Future<void> refresh() async {
    _refreshController.add(null);
  }

  @override
  Future<GroupEntity> createGroup({
    required String title,
    required int weight,
    required int colorValue,
    int? durationInSec,
  }) async {
    final id = const Uuid().v4();
    final companion = GroupsCompanion.insert(
      id: id,
      title: title,
      weight: Value(weight),
      colorValue: colorValue,
      createdAt: Value(DateTime.now()),
      durationInSec: Value(durationInSec ?? 86400),
    );

    await db.into(db.groups).insert(companion);

    return GroupEntity(
      id: id,
      title: title,
      weight: weight,
      groupColor: colorValue,
      habits: const [],
      durationInSec: durationInSec ?? 86400,
    );
  }

  @override
  Future<void> deleteGroup({required String groupId}) async {
    await (db.delete(db.groups)..where((tbl) => tbl.id.equals(groupId))).go();
  }

  @override
  Future<void> addHabitToGroup({
    required String groupId,
    required String habitId,
  }) async {
    final newGroup = await (db.select(db.groups)
          ..where((tbl) => tbl.id.equals(groupId)))
        .getSingle();

    await (db.update(db.habits)..where((tbl) => tbl.id.equals(habitId)))
        .write(HabitsCompanion(groupId: Value(groupId)));

    final performances = await (db.select(db.habitPerformances)
          ..where((tbl) => tbl.habitId.equals(habitId)))
        .get();

    if (performances.isNotEmpty) {
      db.batch((batch) {
        for (final performance in performances) {
          final newTimeKey =
              (performance.performTime.millisecondsSinceEpoch ~/ 1000) ~/
                  newGroup.durationInSec;
          batch.replace(
            db.habitPerformances,
            performance.copyWith(timeKey: newTimeKey),
          );
        }
      });
    }
  }

  @override
  Future<GroupEntity> getGroupWithHabits({required String groupId}) async {
    final group = await (db.select(db.groups)
          ..where((tbl) => tbl.id.equals(groupId)))
        .getSingleOrNull();

    if (group == null) {
      throw Exception('Group with ID $groupId not found'); // Or custom error
    }

    final habits = await (db.select(db.habits)
          ..where((tbl) => tbl.groupId.equals(groupId))
          ..orderBy([
            (h) => OrderingTerm(expression: h.weight, mode: OrderingMode.asc),
          ]))
        .get();

    final habitCompletionCounts = await Future.wait(
      habits.map((h) =>
          db.watchHabitCompletionCount(h.id, group.durationInSec).first),
    );

    final habitEntities = habits.asMap().entries.map((entry) {
      final index = entry.key;
      final h = entry.value;
      return HabitEntity(
        id: h.id,
        title: h.title,
        info: h.info,
        link: h.link,
        weight: h.weight,
        completionCount: habitCompletionCounts[index],
        groupColor: group.colorValue,
      );
    }).toList();

    return GroupEntity(
      id: group.id,
      title: group.title,
      weight: group.weight,
      groupColor: group.colorValue,
      habits: habitEntities,
      durationInSec: group.durationInSec,
    );
  }

  @override
  Stream<List<GroupEntity>> getGroupsListStream() {
    final query = db.select(db.groups).join([
      leftOuterJoin(db.habits, db.habits.groupId.equalsExp(db.groups.id)),
    ])
      ..orderBy([
        OrderingTerm(expression: db.groups.weight, mode: OrderingMode.asc),
      ]);

    return Rx.combineLatest2(
      query.watch(),
      _refreshController.stream.startWith(null),
      (rows, _) => rows,
    ).switchMap((rows) {
      final groupHabits = <Group, List<Habit>>{};
      for (final row in rows) {
        final group = row.readTable(db.groups);
        final habit = row.readTableOrNull(db.habits);
        if (habit != null) {
          groupHabits.putIfAbsent(group, () => []).add(habit);
        } else {
          groupHabits.putIfAbsent(group, () => []);
        }
      }

      if (groupHabits.isEmpty) {
        return Stream.value([]);
      }

      final habitCompletionStreams = <String, Stream<int>>{};
      for (final entry in groupHabits.entries) {
        final group = entry.key;
        final habits = entry.value;
        habits.sort((a, b) => a.weight.compareTo(b.weight));
        for (final habit in habits) {
          habitCompletionStreams[habit.id] =
              db.watchHabitCompletionCount(habit.id, group.durationInSec);
        }
      }

      if (habitCompletionStreams.isEmpty) {
        return Stream.value(groupHabits.keys.map((group) {
          return GroupEntity(
            id: group.id,
            title: group.title,
            weight: group.weight,
            groupColor: group.colorValue,
            durationInSec: group.durationInSec,
            habits: const [],
          );
        }).toList());
      }
      
      return Rx.combineLatest(
        habitCompletionStreams.values,
        (List<int> counts) {
          final habitIdToCount = Map.fromIterables(
            habitCompletionStreams.keys,
            counts,
          );

          return groupHabits.entries.map((entry) {
            final group = entry.key;
            final habits = entry.value;

            return GroupEntity(
              id: group.id,
              title: group.title,
              weight: group.weight,
              groupColor: group.colorValue,
              durationInSec: group.durationInSec,
              habits: habits.where((h) => h != null).map((h) {
                return HabitEntity(
                  id: h!.id,
                  title: h.title,
                  info: h.info,
                  link: h.link,
                  weight: h.weight,
                  completionCount: habitIdToCount[h.id] ?? 0,
                  groupColor: group.colorValue,
                );
              }).toList(),
            );
          }).toList();
        },
      );
    });
  }

  @override
  Future<void> updateGroupName(
      {required String groupId, required String name}) async {
    await (db.update(db.groups)..where((tbl) => tbl.id.equals(groupId)))
        .write(GroupsCompanion(title: Value(name)));
  }

  @override
  Future<void> removeLastDummy() async {
    //TODO remove should mark as deleted and not actual deletion
    final query = db.select(db.groups)
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)
      ])
      ..limit(1);

    final groupToDelete = await query.getSingleOrNull();

    if (groupToDelete != null) {
      await (db.delete(db.groups)
            ..where((tbl) => tbl.id.equals(groupToDelete.id)))
          .go();
    }
  }

  @override
  Future<void> addDummyHabitToFirstGroup() async {
    final query = db.select(db.groups)
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.asc)
      ])
      ..limit(1);

    final firstGroup = await query.getSingleOrNull();

    if (firstGroup != null) {
      final habitId = const Uuid().v4();
      final dummyHabitName = 'Dummy Habit ${DateTime.now().millisecondsSinceEpoch}';

      final companion = HabitsCompanion.insert(
        id: habitId,
        title: dummyHabitName,
        info: const Value('A dummy habit created automatically.'),
        weight: const Value(1),
        groupId: Value(firstGroup.id),
        link: const Value('https://example.com'),
      );

      await db.into(db.habits).insert(companion);
    }
  }

  @override
  Future<void> reorder(List<GroupEntity> groups) async {
    await db.batch((batch) {
      for (int i = 0; i < groups.length; i++) {
        final group = groups[i];
        batch.update(
          db.groups,
          GroupsCompanion(weight: Value(i)),
          where: (tbl) => tbl.id.equals(group.id),
        );
      }
    });
  }
}

