import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_habit_form_dialog_cubit.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/new_habit_form_ui.dart';
import 'new_habit_form_dialog.dart';

class NewHabitFormDialogProvider extends StatelessWidget {
  final void Function({required NewHabitFormUI uiModel}) onConfirm;

  const NewHabitFormDialogProvider(
  {super.key, required  this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewHabitFormDialogCubit(
        onConfirm: onConfirm,
      ),
      child: NewHabitFormDialog(),
    );
  }
}
