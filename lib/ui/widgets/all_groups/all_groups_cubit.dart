import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/groups_list_stream_use_case.dart';
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_manager.dart';
import 'package:injectable/injectable.dart';

import 'all_groups_state.dart';

@injectable
class AllGroupsCubit extends Cubit<AllGroupsState> {
  StreamSubscription? _groupsListSubscription;
  StreamSubscription? _groupsExpandCollapseAllSubscription;


  final GroupsListStreamUseCase groupsListStreamUseCase;
  final ActiveHabitsManager manager;


  AllGroupsCubit({
    required this.groupsListStreamUseCase, required this.manager,
  }) : super(AllGroupsState.initial()) {
    init();
  }

  void init() {
    _groupsListSubscription = groupsListStreamUseCase.stream(null).listen((event) {
      emit(state.copyWith(groupList: event));
    });
    _groupsExpandCollapseAllSubscription = manager.listenToCollapseExpandAll.listen((shouldExpand) {

      if (shouldExpand) {
        expandAll();
      } else {
        collapseAll();
      }
    });
  }

  void toggleGroup(String id) {
    final expandedGroupIds = List<String>.from(state.expandedGroupIds);
    if (expandedGroupIds.contains(id)) {
      expandedGroupIds.remove(id);
    } else {
      expandedGroupIds.add(id);
    }
    emit(
        state.copyWith(expandedGroupIds: expandedGroupIds)
    );
  }


  void collapseAll() {
    emit(state.copyWith(expandedGroupIds: []));
  }

  void expandAll() {
    final expandedGroupIds = List<String>.from(state.groupList.map((e) => e.id));
    emit(state.copyWith(expandedGroupIds: expandedGroupIds));
  }

  @override
  Future<void> close() {
    _groupsListSubscription?.cancel();
    _groupsExpandCollapseAllSubscription?.cancel();
    return super.close();
  }

}
