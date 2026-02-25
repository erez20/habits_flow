import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/ui_models/edit_group_ui_model.dart';
import 'package:habits_flow/ui/ui_models/group_ui_model.dart';
import 'edit_group_form_state.dart';

class EditGroupFormCubit extends Cubit<EditGroupFormState> {
  final GroupUIModel uiModel;
  final void Function({required SelectedGroupUIModel uiModel}) onUpdate;

  EditGroupFormCubit({
    required this.uiModel,
    required this.onUpdate,
  }) : super(EditGroupFormState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }

  void submitForm(Map<String, dynamic> updatedFormData) {
    emit(state.copyWith(isSubmitting: true));
    try {
      final newUIModel = SelectedGroupUIModel(
        title: updatedFormData['title'],
        durationInSec: updatedFormData['durationInSec'],
        color: updatedFormData['group_color'],
      );
      onUpdate(uiModel: newUIModel);
      Fimber.d(
          "Updating Entity: ${newUIModel.title}");
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }





  }
}
