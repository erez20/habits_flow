import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/ui_models/group_ui_model.dart';
import 'package:habits_flow/ui/ui_models/new_habit_form_ui_model.dart';

import 'create_habit_state.dart';

class CreateHabitCubit extends Cubit<CreateHabitState> {
  final AddHabitUseCase addHabitUseCase;
  final GroupUIModel groupUIModel;

  CreateHabitCubit({
    required this.addHabitUseCase,
    required this.groupUIModel,

  }) : super(CreateHabitState.init());

  void addHabit({required NewHabitFormUiModel uiModel}) async{
    addHabitUseCase.exec(
      AddHabitUseCaseParams(
        groupId: groupUIModel.id,
        title: uiModel.title,
        info: uiModel.info,
        link: uiModel.link,
        groupColor: AppColors.getColorValue(groupUIModel.color),
      ),
    );
  }

  MaterialColor get color => groupUIModel.color;
}
