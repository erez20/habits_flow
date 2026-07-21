import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:habits_flow/main/injection.dart';
import 'package:habits_flow/ui/ui_models/group_ui_model.dart';

import 'create_habit_cubit.dart';
import 'create_habit_widget.dart';

class CreateHabitProvider extends StatelessWidget {
  final GroupUIModel groupUIModel;

  const CreateHabitProvider({
    super.key,
    required this.groupUIModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var addHabitUseCase = getIt<AddHabitUseCase>();
        return CreateHabitCubit(
          addHabitUseCase: addHabitUseCase,
          groupUIModel: groupUIModel,

        );
      },
      child: CreateHabitWidget(groupUIModel: groupUIModel),
    );
  }
}
