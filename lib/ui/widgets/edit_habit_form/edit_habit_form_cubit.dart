import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/ui_models/selected_habit_ui_model.dart';

import 'edit_habit_form_state.dart';

class EditHabitFormCubit extends Cubit<EditHabitFormState> {
  final void Function({required SelectedHabitUiModel uiModel}) onUpdate;
  final SelectedHabitUiModel uiModel;

  EditHabitFormCubit({
    required this.onUpdate,
    required this.uiModel,
  }) : super(EditHabitFormState.init());

  Future<void> updateForm(Map<String, dynamic> formData) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      final newUIModel = SelectedHabitUiModel(
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
