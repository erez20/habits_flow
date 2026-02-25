import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/use_cases/group/delete_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/edit_group_use_case.dart';
import 'package:habits_flow/ui/widgets/group/group_state.dart';

import '../../ui_models/group_ui_model.dart';

class GroupCubit extends Cubit<GroupState> {
  final DeleteGroupUseCase deleteGroupUseCase;
  final EditGroupUseCase editGroupUseCase;


  GroupCubit({
    required GroupEntity entity,
    required this.deleteGroupUseCase,
    required this.editGroupUseCase,
  }) : super(GroupState(uiModel: GroupUIModel.fromEntity(entity)));

  void deleteGroup() {
    Fimber.d("deleteGroup ${state.uiModel.id}");
    deleteGroupUseCase.exec(state.uiModel.id);
  }

  void editGroup() {
    Fimber.d("editGroup ${state.uiModel.id}");
    editGroupUseCase.exec(state.uiModel.toEntity());
  }

  void updateEntity(GroupEntity newEntity) {
    emit(GroupState(uiModel: GroupUIModel.fromEntity(newEntity)));
  }
}
