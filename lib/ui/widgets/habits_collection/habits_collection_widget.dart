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
  final GlobalKey _wrapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitsCollectionCubit, HabitCollectionState>(
      builder: (context, state) {
        return Stack(
          children: [
            // LAYER 1: The Habits
            Wrap(
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
                CreateHabitProvider(groupId: state.groupId),
              ],
            ),

            // LAYER 2: Drawing
            Positioned.fill(
              child: DrawingLayerWidget(
                // We pass the key down so the layer knows where to check
                targetKey: _wrapKey,
                onWidgetHit: (data) {
                  if (data is HabitEntity) {
                    print("✅ HIT HABIT: ${data.id}");
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// INTERNAL HELPER WIDGETS
// -----------------------------------------------------------------------------

