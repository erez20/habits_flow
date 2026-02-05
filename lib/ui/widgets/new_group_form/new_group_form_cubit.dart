import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/ui_models/new_group_form_ui_model.dart';
import 'new_group_form_state.dart';

class NewGroupFormCubit extends Cubit<NewGroupFormState> {
  final void Function({required NewGroupFormUIModel uiModel}) onConfirm;

  NewGroupFormCubit({required this.onConfirm}) : super(NewGroupFormState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }

  void submitForm(Map<String, dynamic> formData) {
    emit(state.copyWith(isSubmitting: true));
    try {


      final newUIModel = NewGroupFormUIModel(
        title: formData['title'],

      );
      onConfirm(uiModel: newUIModel);
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }


  }
}
