import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/ui/widgets/group/group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupEntity entity;

  GroupCubit({required this.entity}) : super(GroupState(entity: entity));

  void updateEntity(GroupEntity newEntity) {
    emit(GroupState(entity: newEntity));
  }

  @override
  Future<void> close() {
    Fimber.d("close: GroupCubit ${state.entity}");
    return super.close();
  }
}




