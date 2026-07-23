import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/habit_ui.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/groups_list_stream_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/delete_habit_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/edit_habit_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/reorder_habit_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/reset_habit_use_case.dart';
import 'package:habits_flow/domain/use_cases/shared/refresh_all_use_case.dart';
import 'package:habits_flow/ui/theme/app_colors.dart';
import 'package:habits_flow/ui/screens/active_habits/coordinator/active_habits_coordinator.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/new_group_form_ui.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/selected_habit_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import 'active_habits_screen_state.dart';

class ActiveHabitsScreenCubit extends Cubit<ActiveHabitsScreenState> {
  final ActiveHabitsCoordinator coordinator;
  final AddGroupUseCase addGroupUseCase;
  final GroupsListStreamUseCase groupsListStreamUseCase;
  final ResetHabitUseCase resetHabitUseCase;
  final RefreshAllUseCase refreshAllUseCase;
  final ReorderHabitUseCase reorderHabitUseCase;
  final DeleteHabitUseCase deleteHabitUseCase;
  final EditHabitUseCase editHabitUseCase;

  ActiveHabitsScreenCubit({
    required this.coordinator,
    required this.addGroupUseCase,
    required this.groupsListStreamUseCase,
    required this.resetHabitUseCase,
    required this.refreshAllUseCase,
    required this.reorderHabitUseCase,
    required this.deleteHabitUseCase,
    required this.editHabitUseCase,
  }) : super(ActiveHabitsScreenState.init()) {
    init();
  }

  late final StreamSubscription<HabitUI?> _habitSelectedStreamSubscription;
  late final StreamSubscription<List<GroupEntity>> _groupsStreamSubscription;

  void moveRequest({required String habitId, required int steps}) {
    reorderHabitUseCase.exec(ReorderHabitUseCaseParams(habitId: habitId, steps: steps));
  }

  void init() {
    refreshAllUseCase.exec(null);
    _habitSelectedStreamSubscription = coordinator.listenToHabitSelected.listen(
      (habit) {
        if (habit == null) {
          emit(state.copyWith(clearUiModel: true));
        } else {
          final uiModel = SelectedHabitUI.fromHabit(habit);
          emit(state.copyWith(uiModel: uiModel));
        }
      },
    );
    _groupsStreamSubscription = groupsListStreamUseCase.stream(null).listen((groups) {
      final totalPoints =
          groups.fold<int>(0, (sum, group) => sum + group.points);
      final totalCompletions = groups.fold<int>(
          0,
          (sumGroups, group) =>
              sumGroups +
              group.habits
                  .fold<int>(0, (sum, habit) => sum + habit.completionCount));
      emit(state.copyWith(
        totalPoints: totalPoints,
        totalCompletions: totalCompletions,
      ));
    });
  }

  void addGroup({required NewGroupFormUI uiModel}) {
    Fimber.d('addGroup');
    addGroupUseCase.exec(
      AddGroupUseCaseParams(
        title: uiModel.title,
        weight: 4,
        colorValue: AppColors.getColorValue(uiModel.color),
        durationInSec: uiModel.durationInSec,
      ),
    );
  }

  void clearSelection() {
    coordinator.clearHabitSelection();
  }

  void resetHabit() {
    Fimber.d('resetHabit');
    var uiModel = state.uiModel;
    if (uiModel != null) {
      resetHabitUseCase.exec(ResetHabitUseCaseParams(habitId: uiModel.id));
    }
    clearSelection();
  }

  void expandAll() {
    coordinator.collapseExpandAll(shouldExpand: true);
  }

  void collapseAll() {
    coordinator.collapseExpandAll(shouldExpand: false);
  }

  void deleteHabit(String habitId) {
    deleteHabitUseCase.exec(habitId);
    clearSelection();
  }


  void updateHabit({required SelectedHabitUI uiModel}) {
    final updatedHabit = uiModel.toEntity();
    editHabitUseCase.exec(updatedHabit);
    clearSelection();
  }

  Future<void> onLinkTapped(String url) async{
    final uri = Uri.parse(url);
    var res = await canLaunchUrl(uri);
    if (res) {
      await launchUrl (uri);
    }
  }
  @override
  Future<void> close() {
    _habitSelectedStreamSubscription.cancel();
    _groupsStreamSubscription.cancel();
    return super.close();
  }
}
