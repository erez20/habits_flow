import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'package:habits_flow/ui/widgets/create_habit/create_habit_provider.dart';
import 'package:habits_flow/ui/widgets/habit/habit_provider.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_cubit.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_state.dart';

class HabitsCollectionWidget extends StatelessWidget {


  const HabitsCollectionWidget({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitsCollectionCubit, HabitCollectionState>(
      builder: (context, state) {

        return Center(
          child: Wrap(
            spacing: Constants.habitsSep,
            runSpacing: Constants.habitsSep,
            children: [
              ...state.habits.map((habit) {
                return HabitProvider(
                  key: ValueKey(habit.id),
                  habit: habit,

                );
              }),
              (CreateHabitProvider(
                groupId: state.groupId,
              )),
            ],
          ),
        );
      },
    );
  }
}






/*
 */
