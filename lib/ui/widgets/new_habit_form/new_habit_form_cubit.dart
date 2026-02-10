import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/ui_models/new_habit_form_ui_model.dart';

import 'new_habit_form_state.dart';

class NewHabitFormCubit extends Cubit<NewHabitFormState> {
  final void Function({required NewHabitFormUiModel uiModel}) onConfirm;

  NewHabitFormCubit({required this.onConfirm}) : super(NewHabitFormState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }

  Future<void> submitForm(Map<String, dynamic> formData) async {
    emit(state.copyWith(isSubmitting: true));
    try {


      final newUIModel = NewHabitFormUiModel(
        title: formData['title'],
        info: formData['info']??"",
        link: formData['link']??"",
      );
      onConfirm(uiModel: newUIModel);
      Fimber.d("Saving Entity: ${newUIModel.title} with info: ${newUIModel.info}");
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

}
