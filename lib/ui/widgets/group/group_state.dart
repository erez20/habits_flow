import 'package:equatable/equatable.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

class GroupState extends Equatable {
  final GroupEntity entity;

  const GroupState({required this.entity});

  @override
  List<Object?> get props => [entity];
}