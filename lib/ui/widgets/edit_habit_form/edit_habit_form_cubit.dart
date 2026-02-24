import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

import 'package:habits_flow/ui/ui_models/edit_habit_form_ui_model.dart';

import 'edit_habit_form_state.dart';

class EditHabitFormCubit extends Cubit<EditHabitFormState> {
  final void Function({required EditHabitFormUiModel uiModel}) onUpdate;
  final HabitEntity habit;

  EditHabitFormCubit({
    required this.onUpdate,
    required this.habit,
  }) : super(EditHabitFormState.init());

  Future<void> updateForm(Map<String, dynamic> formData) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      final newUIModel = EditHabitFormUiModel(
        id: habit.id,
        title: formData['title'],
        info: formData['info'] ?? "",
        link: formData['link'] ?? "",
        points: formData['points'],
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
