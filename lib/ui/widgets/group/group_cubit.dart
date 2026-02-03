import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/ui/widgets/group/group_state.dart';

import 'group_ui_model.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit({required GroupEntity entity})
    : super(GroupState(uiModel: GroupUIModel.fromEntity(entity)));

  void updateEntity(GroupEntity newEntity) {
    emit(GroupState(uiModel: GroupUIModel.fromEntity(newEntity)));
  }
}
