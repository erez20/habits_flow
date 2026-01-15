import 'package:habits_flow/domain/entities/group_entity.dart';

abstract class GroupLocalSource {
  Future<GroupEntity> createGroup({
    required String title,
    required int weight,
    required String colorHex,
  });
}

