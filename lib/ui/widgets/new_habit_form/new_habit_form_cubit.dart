import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/widgets/new_habit_form/new_habit_form_ui_model.dart';
import 'new_habit_form_state.dart';

class NewHabitFormCubit extends Cubit<NewHabitFormState> {
  NewHabitFormCubit() : super(NewHabitFormState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }

  Future<void> submitForm(Map<String, dynamic> formData) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      // Simulate API call or Repository update
      await Future.delayed(const Duration(seconds: 1));

      final entity = NewHabitFormUiModel(
        title: formData['title'],
        info: formData['info'],
        link: formData['link'],
      );

      print("Saving Entity: ${entity.title} with info: ${entity.info}");
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

}
