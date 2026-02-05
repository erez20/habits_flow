import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:habits_flow/ui/ui_models/new_habit_form_ui_model.dart';

import 'create_habit_state.dart';

class CreateHabitCubit extends Cubit<CreateHabitState> {
  final AddHabitUseCase addHabitUseCase;
  final String groupId;
  final int groupColor;

  CreateHabitCubit({
    required this.addHabitUseCase,
    required this.groupId,
    required this.groupColor,
  }) : super(CreateHabitState.init());

  void addHabit({required NewHabitFormUiModel uiModel}) async{
    addHabitUseCase.exec(
      AddHabitUseCaseParams(
        groupId: groupId,
        title: uiModel.title,
        info: uiModel.info,
        link: uiModel.link,
        groupColor: groupColor,
      ),
    );
  }
}
