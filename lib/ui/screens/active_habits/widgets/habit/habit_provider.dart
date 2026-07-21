import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/ui_models/habit_ui.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/use_cases/habit/habit_stream_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/perform_habit_use_case.dart';
import 'package:habits_flow/main/injection.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'package:habits_flow/ui/screens/active_habits/coordinator/active_habits_coordinator.dart';

import 'habit_cubit.dart';
import 'habit_widget.dart';

class HabitProvider extends StatelessWidget {
  final HabitUI habit;

  const HabitProvider({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final habitSep = Constants.habitsSep;
    final habitSide = Constants.habitSide(context);
    final habitRepo = getIt<HabitRepo>();
    final habitStreamUseCase = getIt<HabitStreamUseCase>();
    final performHabitUseCase = getIt<PerformHabitUseCase>();
    final coordinator = context.read<ActiveHabitsCoordinator>();

    return BlocProvider(
      create: (context) => HabitCubit(
        habitRepo: habitRepo,
        habit: habit,
        habitStreamUseCase: habitStreamUseCase,
        performHabitUseCase: performHabitUseCase,
        coordinator: coordinator,
      ),
      child: HabitWidget(
        habitsSep: habitSep,
        side: habitSide,
      ),
    );
  }
}
