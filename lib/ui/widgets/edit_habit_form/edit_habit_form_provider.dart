import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/ui_models/selected_habit_ui_model.dart';

import 'edit_habit_form_cubit.dart';
import 'edit_habit_form_widget.dart';

class EditHabitFormProvider extends StatelessWidget {
  final void Function({required SelectedHabitUiModel uiModel}) onUpdate;
  final SelectedHabitUiModel uiModel;

  const EditHabitFormProvider(
      {super.key, required this.onUpdate, required this.uiModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditHabitFormCubit(
        onUpdate: onUpdate,
        uiModel: uiModel,
      ),
      child: EditHabitFormWidget(
        uiModel: uiModel,
      ),
    );
  }
}
