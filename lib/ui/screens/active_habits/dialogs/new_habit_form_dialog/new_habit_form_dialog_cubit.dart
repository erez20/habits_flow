import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/new_habit_form_ui.dart';

import 'new_habit_form_dialog_state.dart';

class NewHabitFormDialogCubit extends Cubit<NewHabitFormDialogState> {
  final void Function({required NewHabitFormUI uiModel}) onConfirm;

  NewHabitFormDialogCubit({required this.onConfirm}) : super(NewHabitFormDialogState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }

  Future<void> submitForm(Map<String, dynamic> formData) async {
    emit(state.copyWith(isSubmitting: true));
    try {


      final newUIModel = NewHabitFormUI(
        title: formData['title'],
        info: formData['info'] ?? "",
        link: formData['link'] ?? "",
        points: formData['points'],
      );
      onConfirm(uiModel: newUIModel);
      Fimber.d(
          "Saving Entity: ${newUIModel.title} with info: ${newUIModel.info}");
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

}
