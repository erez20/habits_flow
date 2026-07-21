import 'package:equatable/equatable.dart';

import 'package:habits_flow/ui/ui_models/group_ui.dart';

class GroupState extends Equatable {
  final GroupUI uiModel;

  const GroupState({required this.uiModel});



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