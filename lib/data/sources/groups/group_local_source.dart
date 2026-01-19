import 'package:habits_flow/domain/entities/group_entity.dart';

abstract class GroupLocalSource {
  Future<GroupEntity> createGroup({
    required String title,
    required int weight,
    required String colorHex,
  });

  Future<void> deleteGroup({required String groupId}) ;

  Future<void> addHabitToGroup({
    required String groupId,
    required String habitId,
  });

  Future<GroupEntity> getGroupWithHabits({required String groupId});
}

