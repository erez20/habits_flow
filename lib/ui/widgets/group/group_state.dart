import 'package:equatable/equatable.dart';

import 'group_ui_model.dart';

class GroupState extends Equatable {
  final GroupUIModel uiModel;

  const GroupState({required this.uiModel});



  @override
  List<Object?> get props => [uiModel];

  GroupState copyWith({
    GroupUIModel? uiModel,
  }) {
    return GroupState(
      uiModel: uiModel ?? this.uiModel,
    );
  }
}