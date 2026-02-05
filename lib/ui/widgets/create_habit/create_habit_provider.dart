import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:habits_flow/injection.dart';

import 'create_habit_cubit.dart';
import 'create_habit_widget.dart';

class CreateHabitProvider extends StatelessWidget {
  final String groupId;
  final int groupColor;

  const CreateHabitProvider({super.key, required this.groupId, required this.groupColor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateHabitCubit(addHabitUseCase: getIt<AddHabitUseCase>(), groupId: groupId, groupColor: groupColor),
      child: CreateHabitWidget(),
    );
  }
}
