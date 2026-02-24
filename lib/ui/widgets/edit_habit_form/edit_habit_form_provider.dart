import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/ui_models/edit_habit_form_ui_model.dart';
import 'edit_habit_form_cubit.dart';
import 'edit_habit_form_widget.dart';

class EditHabitFormProvider extends StatelessWidget {
  final void Function({required EditHabitFormUiModel uiModel}) onUpdate;
  final HabitEntity habit;

  const EditHabitFormProvider(
      {super.key, required this.onUpdate, required this.habit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditHabitFormCubit(
        onUpdate: onUpdate,
        habit: habit,
      ),
      child: EditHabitFormWidget(
        habit: habit,
      ),
    );
  }
}
