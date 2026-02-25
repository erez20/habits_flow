import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/delete_habit_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/edit_habit_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/reorder_habit_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/reset_habit_use_case.dart';
import 'package:habits_flow/domain/use_cases/shared/refresh_all_use_case.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_manager.dart';
import 'package:habits_flow/ui/ui_models/new_group_form_ui_model.dart';
import 'package:habits_flow/ui/ui_models/selected_habit_ui_model.dart';
import 'package:habits_flow/ui/widgets/edit_habit_form/edit_habit_form_provider.dart';

import 'active_habits_screen_state.dart';

class ActiveHabitsScreenCubit extends Cubit<ActiveHabitsScreenState> {
  final ActiveHabitsManager manager;
  final AddGroupUseCase addGroupUseCase;
  final ResetHabitUseCase resetHabitUseCase;
  final RefreshAllUseCase refreshAllUseCase;
  final ReorderHabitUseCase reorderHabitUseCase;
  final DeleteHabitUseCase deleteHabitUseCase;
  final EditHabitUseCase editHabitUseCase;

  ActiveHabitsScreenCubit({
    required this.manager,
    required this.addGroupUseCase,
    required this.resetHabitUseCase,
    required this.refreshAllUseCase,
    required this.reorderHabitUseCase,
    required this.deleteHabitUseCase,
    required this.editHabitUseCase,
  }) : super(ActiveHabitsScreenState.init()) {
    init();
  }

  late final StreamSubscription<HabitEntity?> _habitSelectedStreamSubscription;
  late final StreamSubscription<int> _totalPointsStreamSubscription;
  late final StreamSubscription<int> _totalCompletionsStreamSubscription;

  void moveRequest({required String habitId, required int steps}) {
    reorderHabitUseCase.exec(ReorderHabitUseCaseParams(habitId: habitId, steps: steps));
  }

  void init() {
    refreshAllUseCase.exec(null);
    _habitSelectedStreamSubscription = manager.listenToHabitSelected.listen(
      (habit) {
        if (habit == null) {
          emit(state.copyWith(clearUiModel: true));
        } else {
          emit(
            state.copyWith(
              uiModel: SelectedHabitUiModel.fromHabit(habit),
              selectedHabit: habit,
            ),
          );
        }
      },
    );
    _totalPointsStreamSubscription = manager.listenToTotalPoints.listen((totalPoints) {
      emit(state.copyWith(totalPoints: totalPoints));
    });

    _totalCompletionsStreamSubscription = manager.listenToTotalCompletions.listen((totalCompletions) {
      emit(state.copyWith(totalCompletions: totalCompletions));
    });
  }

  void addGroup({required NewGroupFormUIModel uiModel}) {
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
    manager.clearHabitSelection();
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
    manager.collapseExpandAll(shouldExpand: true);
  }

  void collapseAll() {
    manager.collapseExpandAll(shouldExpand: false);
  }

  void deleteHabit(String habitId) {
    deleteHabitUseCase.exec(habitId);
    clearSelection();
  }


  //TODO MUST remove from here
  void editHabit(BuildContext context,SelectedHabitUiModel uiModel) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => EditHabitFormProvider(
          uiModel: uiModel,
          onUpdate: ({required SelectedHabitUiModel uiModel}) {
            final updatedHabit = uiModel.toEntity();
            editHabitUseCase.exec(updatedHabit);
            clearSelection();
          },
        ),
      );
  }

  @override
  Future<void> close() {
    _habitSelectedStreamSubscription.cancel();
    _totalPointsStreamSubscription.cancel();
    _totalCompletionsStreamSubscription.cancel();
    return super.close();
  }
}
