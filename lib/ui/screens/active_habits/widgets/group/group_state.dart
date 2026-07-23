import 'package:equatable/equatable.dart';

import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';

class GroupState extends Equatable {
  final GroupUI uiModel;

  const GroupState({required this.uiModel});

  factory GroupState.init({required GroupUI group}) =>
      GroupState(uiModel: group);

  @override
  List<Object?> get props => [uiModel];

  GroupState copyWith({
    GroupUI? uiModel,
  }) {
    return GroupState(
      uiModel: uiModel ?? this.uiModel,
    );
  }
}