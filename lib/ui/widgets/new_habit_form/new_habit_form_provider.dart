import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_habit_form_cubit.dart';
import 'new_habit_form_widget.dart';

class NewHabitFormProvider extends StatelessWidget {
  const NewHabitFormProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewHabitFormCubit(),
      child: NewHabitFormWidget(),
    );
  }
}
