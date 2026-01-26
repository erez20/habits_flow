import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/common/constants.dart';

class HabitsCollectionWidget extends StatelessWidget {

  const HabitsCollectionWidget({
    super.key,


  });



  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    // return Wrap(
    //   key: ValueKey(group.id),
    //   children: [
    //     ...group.habits.map((habit) {
    //       return HabitItemWidget(
    //         key: ValueKey(habit.id),
    //         habit: habit,
    //       );
    //     }),
    //     (Container(
    //       height: 100,
    //       width: 100,
    //       color: Colors.orange,
    //     )),
    //   ],
    // );
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

