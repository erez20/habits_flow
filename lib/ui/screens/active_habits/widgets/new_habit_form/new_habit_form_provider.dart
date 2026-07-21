import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_habit_form_cubit.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/new_habit_form_ui.dart';
import 'new_habit_form_widget.dart';

class NewHabitFormProvider extends StatelessWidget {
  final void Function({required NewHabitFormUI uiModel}) onConfirm;

  const NewHabitFormProvider(
  {super.key, required  this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewHabitFormCubit(
        onConfirm: onConfirm,
      ),
      child: NewHabitFormWidget(),
    );
  }
}
