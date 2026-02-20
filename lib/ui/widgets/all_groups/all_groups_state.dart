import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

class AllGroupsState extends Equatable {
  final List<GroupEntity> groupList;
  final List<String> expandedGroupIds;
  final bool isInit;

  const AllGroupsState({
    required this.groupList,
    required this.expandedGroupIds,
    required this.isInit,
  });

  factory AllGroupsState.initial() {
    return AllGroupsState(groupList: [], expandedGroupIds: [], isInit: true);
  }

  @override
  List<Object?> get props => [groupList, expandedGroupIds, isInit];

  bool get isEmpty => groupList.isEmpty;

  AllGroupsState copyWith({
    List<GroupEntity>? groupList,
    List<String>? expandedGroupIds,
    bool? isInit,
  }) {
    return AllGroupsState(
      groupList: groupList ?? this.groupList,
      expandedGroupIds: expandedGroupIds ?? this.expandedGroupIds,
      isInit: isInit ?? this.isInit,
    );
  }

  bool isGroupExpanded(String id) => expandedGroupIds.contains(id);
}
