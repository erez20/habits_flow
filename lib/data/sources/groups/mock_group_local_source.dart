import 'package:habits_flow/data/sources/groups/group_local_source.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GroupLocalSource)
class GroupLocalSourceMock extends GroupLocalSource {
  static int i = 1;

  @override
  Future<GroupEntity> createGroup({
    required String title,
    required int weight,
    required String colorHex,
  }) {
    return Future.value(
      GroupEntity(
        id: i.toString(),
        title: title,
        weight: weight,
        habits: [],
        colorHex: colorHex,
      ),
    );
  }

  @override
  Future<void> deleteGroup({required String groupId}) {
    return Future.value();
  }
}
