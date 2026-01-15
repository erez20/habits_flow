import 'package:habits_flow/data/sources/group_local_source.dart';
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
  }) {
    // TODO: implement addHabitToGroup
    throw UnimplementedError();
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
      _updateMap(group);
      _updateStream();
      return Success(group);
    } on Exception catch (e){
      return Failure(error: DatabaseError(message: e.toString()));
    }
  }

  GroupEntity _updateMap(GroupEntity group) => _groupsMap[group.id] = group;


  @override
  Future<DomainResponse<void>> deleteGroup({required String groupId}) {
    // TODO: implement deleteGroup
    throw UnimplementedError();
  }

  @override
  Future<DomainResponse<void>> removeHabitFromGroup({
    required String groupId,
    required HabitEntity habit,
  }) {
    // TODO: implement removeHabitFromGroup
    throw UnimplementedError();
  }

  void _updateStream() => _groupsSubject.add(Map.unmodifiable(_groupsMap));

  void dispose() => _groupsSubject.close();

}
