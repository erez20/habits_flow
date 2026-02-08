import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/reset_habit_use_case.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_manager.dart';
import 'package:habits_flow/ui/ui_models/new_group_form_ui_model.dart';
import 'package:habits_flow/ui/ui_models/selected_habit_ui_model.dart';

import 'active_habits_screen_state.dart';

class ActiveHabitsScreenCubit extends Cubit<ActiveHabitsScreenState> {
  final ActiveHabitsManager manager;
  final AddGroupUseCase addGroupUseCase;
  final ResetHabitUseCase resetHabitUseCase;

  ActiveHabitsScreenCubit({
    required this.manager,
    required this.addGroupUseCase,
    required this.resetHabitUseCase,
  }) : super(ActiveHabitsScreenState.init()) {
    init();
  }

  late final StreamSubscription<HabitEntity?> _habitSelectedStreamSubscription;

  void init() {
    _habitSelectedStreamSubscription = manager.listenToHabitSelected.listen((
      habit,
    ) {
      if (habit == null) {
        emit(state.copyWith(clearUiModel: true));
      } else {
        emit(
          state.copyWith(
            uiModel: SelectedHabitUiModel.fromHabit(habit),
          ),
        );
      }
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
      resetHabitUseCase.exec(ResetHabitUseCaseParams(habitId: uiModel.habitId));
    }
    clearSelection();
  }

  @override
  Future<void> close() {
    _habitSelectedStreamSubscription.cancel();
    return super.close();
  }
}
