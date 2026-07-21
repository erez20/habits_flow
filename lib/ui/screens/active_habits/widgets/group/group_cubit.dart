import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/delete_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/edit_group_use_case.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/selected_group_ui.dart';
import 'package:habits_flow/ui/screens/active_habits/widgets/group/group_state.dart';

import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';

class GroupCubit extends Cubit<GroupState> {
  final DeleteGroupUseCase deleteGroupUseCase;
  final EditGroupUseCase editGroupUseCase;


  GroupCubit({
    required GroupUI group,
    required this.deleteGroupUseCase,
    required this.editGroupUseCase,
  }) : super(GroupState(uiModel: group));

  void deleteGroup() {
    Fimber.d("deleteGroup ${state.uiModel.id}");
    deleteGroupUseCase.exec(state.uiModel.id);
  }

  void editGroup({required SelectedGroupUI uiModel}) {
    Fimber.d("editGroup ${state.uiModel.id}");
    final entity = uiModel.toEntity(groupUI: state.uiModel);
    editGroupUseCase.exec(entity);
  }

  void updateGroup(GroupUI newGroup) {
    emit(GroupState(uiModel: newGroup));
  }
}
