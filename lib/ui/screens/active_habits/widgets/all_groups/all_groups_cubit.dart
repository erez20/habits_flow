import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/groups_list_stream_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/reorder_groups_use_case.dart';
import 'package:habits_flow/ui/screens/active_habits/coordinator/active_habits_coordinator.dart';
import 'package:habits_flow/ui/ui_models/group_ui.dart';
import 'package:injectable/injectable.dart';

import 'all_groups_state.dart';

@injectable
class AllGroupsCubit extends Cubit<AllGroupsState> {
  StreamSubscription? _groupsListSubscription;
  StreamSubscription? _groupsExpandCollapseAllSubscription;

  final GroupsListStreamUseCase groupsListStreamUseCase;
  final ReorderGroupsUseCase reorderGroupsUseCase;

  final ActiveHabitsCoordinator coordinator;

  AllGroupsCubit({
    required this.groupsListStreamUseCase,
    required this.reorderGroupsUseCase,
    required this.coordinator,
  }) : super(AllGroupsState.initial()) {
    init();
  }

  void init() {
    _groupsListSubscription = groupsListStreamUseCase.stream(null).listen((
      event,
    ) {
      final groups = event.map(GroupUI.fromEntity).toList();
      final totalPoints = groups.fold<int>(0, (sum, group) => sum + group.points);
      final totalCompletion = groups.fold<int>(0, (sumGroups, group) => sumGroups + group.habits.fold<int>(0, (sum, habit) => sum + habit.completionCount));


      coordinator.updateTotalPoints(totalPoints);
      coordinator.updateTotalCompletion(totalCompletion);

      final expandedGroupIds = List<String>.from(state.expandedGroupIds);
      var groupWasAdded = state.groupList.length < groups.length;
      if (!state.isInit && groupWasAdded) {
        expandedGroupIds.add(groups.last.id);
      }
      emit(
        state.copyWith(
          groupList: groups,
          expandedGroupIds: expandedGroupIds,
          isInit: false,
        ),
      );
    });
    _groupsExpandCollapseAllSubscription = coordinator.listenToCollapseExpandAll
        .listen((shouldExpand) {
          if (shouldExpand) {
            expandAll();
          } else {
            collapseAll();
          }
        });
  }

  void reorderGroups(int oldIndex, int newIndex) {
    var newIndexA = newIndex;
    if (oldIndex < newIndexA) {
      newIndexA -= 1;
    }
    final groups = List<GroupUI>.from(state.groupList);
    final group = groups.removeAt(oldIndex);
    groups.insert(newIndexA, group);
    emit(state.copyWith(groupList: groups));
    reorderGroupsUseCase.exec(groups.map((g) => g.toEntity()).toList());
  }

  void toggleGroup(String id) {
    final expandedGroupIds = List<String>.from(state.expandedGroupIds);
    final isExpanding = !expandedGroupIds.contains(id);

    if (isExpanding) {
      expandedGroupIds.add(id);
    } else {
      expandedGroupIds.remove(id);
    }
    emit(state.copyWith(
      expandedGroupIds: expandedGroupIds,
      groupJustToggled: isExpanding ? id : null,
    ));
  }

  void groupExpansionScrolled() {
    emit(state.copyWith(clearGroupJustToggled: true));
  }

  void collapseAll() {
    emit(state.copyWith(expandedGroupIds: []));
  }

  void expandAll() {
    final expandedGroupIds = List<String>.from(
      state.groupList.map((e) => e.id),
    );
    emit(state.copyWith(expandedGroupIds: expandedGroupIds));
  }

  @override
  Future<void> close() {
    _groupsListSubscription?.cancel();
    _groupsExpandCollapseAllSubscription?.cancel();
    return super.close();
  }
}
