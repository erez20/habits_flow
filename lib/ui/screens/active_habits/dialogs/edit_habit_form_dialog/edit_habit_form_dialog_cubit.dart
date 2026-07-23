import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/selected_habit_ui.dart';

import 'edit_habit_form_dialog_state.dart';

class EditHabitFormDialogCubit extends Cubit<EditHabitFormDialogState> {
  final void Function({required SelectedHabitUI uiModel}) onUpdate;
  final SelectedHabitUI uiModel;

  EditHabitFormDialogCubit({
    required this.onUpdate,
    required this.uiModel,
  }) : super(EditHabitFormDialogState.init());

  Future<void> updateForm(Map<String, dynamic> formData) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      final newUIModel = SelectedHabitUI(
        id: uiModel.id,
        title: formData['title'],
        info: formData['info'] ?? "",
        link: formData['link'] ?? "",
        points: formData['points'],
        weight: uiModel.weight,
        completionCount: uiModel.completionCount,
        color: uiModel.color,

      );
      onUpdate(uiModel: newUIModel);
      Fimber.d(
          "Updating Entity: ${newUIModel.title} with info: ${newUIModel.info}");
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
