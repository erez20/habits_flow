import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

class AllGroupsState extends Equatable {
  final List<GroupEntity> groupList;
  final List<String> expandedGroupIds;
  final bool isInit;
  final String? groupJustToggled;

  const AllGroupsState({
    required this.groupList,
    required this.expandedGroupIds,
    required this.isInit,
    this.groupJustToggled,
  });

  factory AllGroupsState.initial() {
    return const AllGroupsState(
      groupList: [],
      expandedGroupIds: [],
      isInit: true,
      groupJustToggled: null,
    );
  }

  @override
  List<Object?> get props => [groupList, expandedGroupIds, isInit, groupJustToggled];

  bool get isEmpty => groupList.isEmpty;

  AllGroupsState copyWith({
    List<GroupEntity>? groupList,
    List<String>? expandedGroupIds,
    bool? isInit,
    String? groupJustToggled,
    bool clearGroupJustToggled = false,
  }) {
    return AllGroupsState(
      groupList: groupList ?? this.groupList,
      expandedGroupIds: expandedGroupIds ?? this.expandedGroupIds,
      isInit: isInit ?? this.isInit,
      groupJustToggled:
          clearGroupJustToggled ? null : groupJustToggled ?? this.groupJustToggled,
    );
  }

  bool isGroupExpanded(String id) => expandedGroupIds.contains(id);
}
