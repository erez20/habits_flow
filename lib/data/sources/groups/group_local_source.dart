import 'package:habits_flow/domain/entities/group_entity.dart';

abstract class GroupLocalSource {
  Future<GroupEntity> createGroup({
    required String title,
    required int weight,
    required int colorValue,
    int? durationInSec,
  });

  Future<void> deleteGroup({required String groupId}) ;

  Future<void> addHabitToGroup({
    required String groupId,
    required String habitId,
  });

  Future<GroupEntity> getGroupWithHabits({required String groupId});

  Stream<List<GroupEntity>> getGroupsListStream();

  Future<void> updateGroupName({
    required String groupId,
    required String name,
  });

  Future<void> removeLastDummy();

  Future<void> addDummyHabitToFirstGroup();

  Future<void> refresh();

  Future<void> reorder(List<GroupEntity> groups);
}
