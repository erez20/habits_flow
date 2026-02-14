import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';

import 'habit_cubit.dart';
import 'habit_state.dart';

class HabitWidget extends StatelessWidget {
  final double habitsSep;
  final double side;

  const HabitWidget({
    super.key,
    required this.habitsSep,
    required this.side,
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
          var materialColor = AppColors.getMaterialColor(state.habit.groupColor); //use ui model!!!
          return Container(
            width: side,
            height: side,
            decoration: BoxDecoration(
              color: state.habit.isUncompleted ? materialColor[50] : materialColor[400],
              border: Border.all(
                color: AppColorsConst.border,
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
