import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/new_habit_form_ui.dart';

import 'create_habit_state.dart';

class CreateHabitCubit extends Cubit<CreateHabitState> {
  final AddHabitUseCase addHabitUseCase;
  final GroupUI groupUI;

  CreateHabitCubit({
    required this.addHabitUseCase,
    required this.groupUI,

  }) : super(CreateHabitState.init());

  void addHabit({required NewHabitFormUI uiModel}) async {
    addHabitUseCase.exec(
      AddHabitUseCaseParams(
        groupId: groupUI.id,
        title: uiModel.title,
        info: uiModel.info,
        link: uiModel.link,
        groupColor: AppColors.getColorValue(groupUI.color),
        points: uiModel.points,
      ),
    );
  }

  MaterialColor get color => groupUI.color;
}
