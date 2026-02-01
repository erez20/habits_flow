import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
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

    return BlocProvider(
      create: (context) => HabitCubit(habit: habit),
      child: HabitWidget(
        habitsSep: habitSep,
        size: habitSize,
        color: Colors.cyan,
      ),
    );
  }
}
