import 'package:habits_flow/data/sources/groups/group_local_source.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/responses/domain_error.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: GroupRepo)
class GroupRepoImpl extends GroupRepo {

  final GroupLocalSource groupLocalSource;

  GroupRepoImpl({
    required this.groupLocalSource,
  });

  final Map<String, GroupEntity> _groupsMap = {};
  final _groupsSubject =
  BehaviorSubject<Map<String, GroupEntity>>.seeded({});

  @override
  Stream<GroupEntity> groupStream({required String groupId}) =>
      _groupsSubject.stream
          .map((groups) => groups[groupId])
          .whereNotNull()
          .distinct();

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
      _addToMap(updatedGroup);
      _updateStream();
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
      _addToMap(group);
      _updateStream();
      return Success(group);
    } on Exception catch (e){
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  @override
  Future<DomainResponse<void>> deleteGroup({required String groupId}) async{
    try {
      await groupLocalSource.deleteGroup(groupId: groupId);
      _removeFromMap(groupId);
      _updateStream();
      return Success(null);
    } on Exception catch (e){
      return Failure(error: DatabaseError(message: e.toString()));
    }

  }

  @override
  Future<DomainResponse<List<String>>> getGroupIdsList() async {
    try {
      final ids = await groupLocalSource.getGroupIdsList();
      return Success(ids);
    } on Exception catch (e) {
      return Failure(error: DatabaseError(message: e.toString()));

    }
  }

  GroupEntity _addToMap(GroupEntity group) => _groupsMap[group.id] = group;


  void _removeFromMap(String groupId) =>_groupsMap.remove(groupId);

  void _updateStream() => _groupsSubject.add(Map.unmodifiable(_groupsMap));

  void dispose() => _groupsSubject.close();

}
