import 'package:habits_flow/domain/entities/group_entity.dart';

abstract class GroupLocalSource {
  Future<GroupEntity> createGroup({
    required String title,
    required int weight,
    required int colorValue,
    required int duration,
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
}
