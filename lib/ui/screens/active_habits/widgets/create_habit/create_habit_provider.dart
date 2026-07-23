import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:habits_flow/core/di/di.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';

import 'create_habit_cubit.dart';
import 'create_habit_widget.dart';

class CreateHabitProvider extends StatelessWidget {
  final GroupUI groupUI;

  const CreateHabitProvider({
    super.key,
    required this.groupUI,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var addHabitUseCase = getIt<AddHabitUseCase>();
        return CreateHabitCubit(
          addHabitUseCase: addHabitUseCase,
          groupUI: groupUI,

        );
      },
      child: CreateHabitWidget(groupUI: groupUI),
    );
  }
}
