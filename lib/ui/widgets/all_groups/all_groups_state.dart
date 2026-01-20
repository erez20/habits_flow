import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

class AllGroupsState extends Equatable{
  final List<GroupEntity> groupList;
  const AllGroupsState({required this.groupList});

  factory AllGroupsState.initial() {
    return const AllGroupsState(groupList: []);
  }

  AllGroupsState copyWith({List<GroupEntity>? list}) {
    return AllGroupsState(
      groupList: list ?? this.groupList,
    );
  }

  @override
  List<Object?> get props => [groupList];

}