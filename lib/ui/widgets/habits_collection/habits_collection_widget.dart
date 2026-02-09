import 'package:fimber/fimber.dart' show Fimber;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'package:habits_flow/ui/widgets/common/drawing_layer/drawing_layer_widget.dart';
import 'package:habits_flow/ui/widgets/create_habit/create_habit_provider.dart';
import 'package:habits_flow/ui/widgets/habit/habit_provider.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_cubit.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_state.dart';

class HabitsCollectionWidget extends StatefulWidget {
  const HabitsCollectionWidget({super.key});

  @override
  State<HabitsCollectionWidget> createState() => _HabitsCollectionWidgetState();
}

class _HabitsCollectionWidgetState extends State<HabitsCollectionWidget> {
  // This key is essential for the DrawingLayer to locate the RenderBox of the Wrap
  final GlobalKey _wrapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitsCollectionCubit, HabitCollectionState>(
      builder: (context, state) {
        return DrawingLayerWidget(
          onWidgetHit: (data) {
            Fimber.d("onWidgetHit $data");
            if (data is HabitEntity) {
              var cubit = context.read<HabitsCollectionCubit>();
              cubit.onHabitDrown(data);
            }
          },
          child: Wrap(
            key: _wrapKey,
            alignment: WrapAlignment.start,
            spacing: Constants.habitsSep,
            runSpacing: Constants.habitsSep,
            children: [
              ...state.habits.map((habit) {
                return MetaData(
                  behavior: HitTestBehavior.opaque,
                  metaData: habit,
                  child: HabitProvider(
                    key: ValueKey(habit.id),
                    habit: habit,
                  ),
                );
              }),
              CreateHabitProvider(
                groupId: state.groupId,
                groupColor: context
                    .read<HabitsCollectionCubit>()
                    .group
                    .groupColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
