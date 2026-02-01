import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/use_cases/habit/habit_stream_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/perform_habit_use_case.dart';
import 'package:habits_flow/injection.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'habit_cubit.dart';
import 'habit_widget.dart';

class HabitProvider extends StatelessWidget {
  final HabitEntity habit;

  const HabitProvider({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final habitSep = Constants.habitsSep;
    final habitSize = Constants.habitSize(context);
    final habitRepo = getIt<HabitRepo> ();
    final habitStreamUseCase = getIt<HabitStreamUseCase> ();
    final performHabitUseCase = getIt<PerformHabitUseCase> ();
    return BlocProvider(
      create: (context) => HabitCubit(habitRepo: habitRepo, habit: habit, habitStreamUseCase: habitStreamUseCase, performHabitUseCase: performHabitUseCase,),
      child: HabitWidget(
        habitsSep: habitSep,
        size: habitSize,
        color: Colors.cyan,
      ),
    );
  }
}
