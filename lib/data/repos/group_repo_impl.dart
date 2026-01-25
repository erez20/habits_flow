import 'dart:math';

import 'package:fimber/fimber.dart';
import 'package:habits_flow/data/sources/groups/group_local_source.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/responses/domain_error.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GroupRepo)
class GroupRepoImpl extends GroupRepo {

  final GroupLocalSource groupLocalSource;

  GroupRepoImpl({
    required this.groupLocalSource,
  });

  @override
  Stream<List<GroupEntity>> getGroupsListStream() {
    return groupLocalSource.getGroupsListStream();
  }

  @override
  Future<DomainResponse<GroupEntity>> addHabitToGroup({
    required String groupId,
    required HabitEntity habit,
  }) async {
    try {
      await groupLocalSource.addHabitToGroup(
        groupId: groupId,
        habitId: habit.id,
      );
      final updatedGroup =
          await groupLocalSource.getGroupWithHabits(groupId: groupId);
      return Success(updatedGroup);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Future<DomainResponse<GroupEntity>> createGroup({
    required String title,
    required int weight,
    required String colorHex,
  }) async {
    try {
      final group = await groupLocalSource.createGroup(
        title: title,
        weight: weight,
        colorHex: colorHex,
      );
      return Success(group);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Future<DomainResponse<void>> deleteGroup({required String groupId}) async {
    try {
      await groupLocalSource.deleteGroup(groupId: groupId);
      return Success(null);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Stream<GroupEntity> groupStream({required String groupId}) {
    return getGroupsListStream().map((groups) {
      return groups.firstWhere((group) => group.id == groupId);
    });
  }

  @override
  Future<DomainResponse<void>> generateDummyGroupName(
      {required String groupId}) async {
    try {
      const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
      final random = Random();
      final dummyName = String.fromCharCodes(
        Iterable.generate(
          6,
          (_) => chars.codeUnitAt(
            random.nextInt(chars.length),
          ),
        ),
      );
      await groupLocalSource.updateGroupName(
          groupId: groupId, name: dummyName);
      return Success(null);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Future<DomainResponse<void>> removeLastDummy() async {
    try {
      await groupLocalSource.removeLastDummy();
      Fimber.d("Last dummy group removed successfully");
      return const Success(null);
    } on Exception catch (e) {
      Fimber.e("Error removing last dummy group: $e");
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Future<DomainResponse<void>> addDummyHabitToFirstGroup() async {
    try {
      await groupLocalSource.addDummyHabitToFirstGroup();
      return const Success(null);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }
}
