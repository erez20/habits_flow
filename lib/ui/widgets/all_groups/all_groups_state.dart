import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

class AllGroupsState extends Equatable{
  final List<GroupEntity> groupList;
  final List<String> expandedGroupIds;
   const AllGroupsState({required this.groupList, required this.expandedGroupIds});

  factory AllGroupsState.initial() {
    return  AllGroupsState(groupList: [], expandedGroupIds: []);
  }


  @override
  List<Object?> get props => [groupList, expandedGroupIds];



  AllGroupsState copyWith({
    List<GroupEntity>? groupList,
    List<String>? expandedGroupIds,
  }) {
    return AllGroupsState(
      groupList: groupList ?? this.groupList,
      expandedGroupIds: expandedGroupIds ?? this.expandedGroupIds,
    );
  }
}