import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';

abstract class GroupRepo {

  Stream<GroupEntity> groupStream({required String groupId});

  Future<DomainResponse<GroupEntity>> createGroup({
    required String title,
    required int weight,
    required int colorValue,
    int? durationInSec,
  });

  Future<DomainResponse<void>> deleteGroup({
    required String groupId,
  });

    Future<DomainResponse<GroupEntity>>  addHabitToGroup({
      required String groupId,
      required HabitEntity habit,
    });

  

    Stream<List<GroupEntity>> getGroupsListStream();

  Future<DomainResponse<void>> removeLastDummy();

  Future<DomainResponse<void>> addDummyHabitToFirstGroup();

  Future<DomainResponse<void>> generateDummyGroupName({
    required String groupId,
  });

  Future<void> refresh();
}