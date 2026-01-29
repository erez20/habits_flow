import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'package:habits_flow/ui/widgets/create_habit/create_habit_provider.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_cubit.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_state.dart';

class HabitsCollectionWidget extends StatelessWidget {
  final double Function(BuildContext context) getHabitSize;

  const HabitsCollectionWidget({
    super.key,
    required this.getHabitSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitsCollectionCubit, HabitCollectionState>(
      builder: (context, state) {
        final habitSize = getHabitSize(context);
        return Wrap(
          children: [
            ...state.habits.map((habit) {
              return HabitItemWidget(
                key: ValueKey(habit.id),
                habit: habit,
              );
            }),
            (CreateHabitProvider(
              groupId: state.groupId,
            )),
          ],
        );
      },
    );
  }
}

class HabitItemWidget extends StatelessWidget {
  final HabitEntity habit;

  const HabitItemWidget({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final habitsSep = Constants.habitsSep;
    final size = Constants.habitWidth(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: habitsSep, vertical: habitsSep),
      child: Container(
        color: Colors.orange,
        width: size,
        height: size,
        child: Text(habit.title),
      ),
    );
  }
}
