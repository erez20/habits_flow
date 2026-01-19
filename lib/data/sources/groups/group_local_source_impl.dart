import 'package:drift/drift.dart';
import 'package:habits_flow/data/db/database.dart';
import 'package:habits_flow/data/sources/groups/group_local_source.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: GroupLocalSource)
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
}
