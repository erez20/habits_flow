import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/selected_habit_ui.dart';

import 'edit_habit_form_dialog_cubit.dart';
import 'edit_habit_form_dialog.dart';

class EditHabitFormDialogProvider extends StatelessWidget {
  final void Function({required SelectedHabitUI uiModel}) onUpdate;
  final SelectedHabitUI uiModel;

  const EditHabitFormDialogProvider(
      {super.key, required this.onUpdate, required this.uiModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditHabitFormDialogCubit(
        onUpdate: onUpdate,
        uiModel: uiModel,
      ),
      child: EditHabitFormDialog(
        uiModel: uiModel,
      ),
    );
  }
}
