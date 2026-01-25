import 'package:drift/drift.dart';
import 'package:habits_flow/data/db/database.dart';
import 'package:habits_flow/data/sources/groups/group_local_source.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Injectable(as: GroupLocalSource)
class GroupLocalSourceImpl implements GroupLocalSource {
  final AppDatabase db;

  GroupLocalSourceImpl(this.db);

  @override
  Future<GroupEntity> createGroup({
    required String title,
    required int weight,
    required String colorHex,
  }) async {
    final id = const Uuid().v4();
    final companion = GroupsCompanion.insert(
      id: id,
      title: title,
      weight: Value(weight),
      colorHex: colorHex,
      createdAt: Value(DateTime.now()),
    );

    await db.into(db.groups).insert(companion);

    return GroupEntity(
      id: id,
      title: title,
      weight: weight,
      colorHex: colorHex,
      habits: const [],
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
    await (db.update(db.habits)..where((tbl) => tbl.id.equals(habitId)))
        .write(HabitsCompanion(groupId: Value(groupId)));
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
          ..where((tbl) => tbl.groupId.equals(groupId)))
        .get();

    final habitEntities = habits
        .map(
          (h) => HabitEntity(
            id: h.id,
            title: h.title,
            info: h.info,
            weight: h.weight,
            completionCount: 0, // Calculated at repo or use case level
          ),
        )
        .toList();

    return GroupEntity(
      id: group.id,
      title: group.title,
      weight: group.weight,
      colorHex: group.colorHex,
      habits: habitEntities,
    );
  }

  @override
  Stream<List<GroupEntity>> getGroupsListStream() {
    final query = db.select(db.groups);

    return query.watch().asyncMap((groups) async {
      final groupsWithHabits = <GroupEntity>[];
      for (final group in groups) {
        final habits = await (db.select(db.habits)
              ..where((tbl) => tbl.groupId.equals(group.id)))
            .get();
        final habitEntities = habits
            .map(
              (h) => HabitEntity(
                id: h.id,
                title: h.title,
                info: h.info,
                weight: h.weight,
                completionCount: 0,
              ),
            )
            .toList();
        groupsWithHabits.add(
          GroupEntity(
            id: group.id,
            title: group.title,
            weight: group.weight,
            colorHex: group.colorHex,
            habits: habitEntities,
          ),
        );
      }
      return groupsWithHabits;
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
      );

      await db.into(db.habits).insert(companion);
    }
  }
}
