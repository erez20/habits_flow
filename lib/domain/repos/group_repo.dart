import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';

abstract class GroupRepo {

  Stream<GroupEntity> groupStream({required String groupId});

  Future<DomainResponse<GroupEntity>> createGroup({
    required String title,
    required int weight,
    required String colorHex,
  });

  Future<DomainResponse<void>> deleteGroup({
    required String groupId,
  });

  Future<DomainResponse<GroupEntity>>  addHabitToGroup({
    required String groupId,
    required HabitEntity habit,
  });

  Future<DomainResponse<void>>  removeHabitFromGroup({
    required String groupId,
    required HabitEntity habit,
  });

}