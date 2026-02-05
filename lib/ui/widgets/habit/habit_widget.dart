import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'habit_cubit.dart';
import 'habit_state.dart';

class HabitWidget extends StatelessWidget {
  final double habitsSep;
  final double side;
  final MaterialColor color;

  const HabitWidget({
    super.key,
    required this.habitsSep,
    required this.side,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HabitCubit>();

    return GestureDetector(
      onTap: cubit.performHabit,
      onLongPress: cubit.onLongPress,
      child: BlocBuilder<HabitCubit, HabitState>(
        builder: (context, state) {
          var completionCount = state.habit.completionCount;
          return Container(
            width: side,
            height: side,
            decoration: BoxDecoration(
              color: state.habit.isUncompleted ? Colors.white : color[50],
              border: Border.all(
                color: color,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    state.habit.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (completionCount >0) Positioned(
                  top: 2,
                  right: 2,
                  child: Text("$completionCount")
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
