import 'package:fimber/fimber.dart' show Fimber;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'package:habits_flow/ui/ui_models/group_ui_model.dart';
import 'package:habits_flow/ui/widgets/common/drawing_layer/drawing_layer_widget.dart';
import 'package:habits_flow/ui/widgets/create_habit/create_habit_provider.dart';
import 'package:habits_flow/ui/widgets/habit/habit_provider.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_cubit.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_state.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

class HabitsCollectionWidget extends StatefulWidget {
  const HabitsCollectionWidget({super.key});

  @override
  State<HabitsCollectionWidget> createState() => _HabitsCollectionWidgetState();
}

class _HabitsCollectionWidgetState extends State<HabitsCollectionWidget> {
  final GlobalKey _wrapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HabitsCollectionCubit>();

    return BlocBuilder<HabitsCollectionCubit, HabitCollectionState>(
      builder: (context, state) {

        final generatedChildren = state.init?null:[
          ...state.habits.map((habit) {
            return MetaData(
              key: ValueKey(habit.id), // CRITICAL: Key goes here
              behavior: HitTestBehavior.opaque,
              metaData: habit,
              child: HabitProvider(habit: habit),
            );
          }),
          CreateHabitProvider(
            key: const ValueKey('create_button'),
            groupUIModel: GroupUIModel.fromEntity(state.group),
          ),
        ];

        return DrawingLayerWidget(
          onWidgetHit: (data) {
            Fimber.d("onWidgetHit $data");
            if (data is HabitEntity) {
              cubit.onHabitDrown(data);
            }
          },
          onDrawingStarts: cubit.onDrawingStarts,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),

            // 2. Wrap with ReorderableBuilder for animations
            child: ReorderableBuilder(
              enableDraggable: true,
              // This duration controls the implicit slide when state changes
              positionDuration: const Duration(milliseconds: 300),
              onReorder: (reorderedListFunction) {
                // Handled by BLoC state changes via Joystick, leave empty
              },
              builder: (animatedChildren) {
                return GridView.count(
                  key: _wrapKey,
                  shrinkWrap: true, // Replaces Wrap's natural sizing
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: Constants.habitsPerRow, // Your specific column count
                  mainAxisSpacing: Constants.habitsSep,
                  crossAxisSpacing: Constants.habitsSep,
                  children: animatedChildren,
                );
              },
              children: generatedChildren,
            ),
          ),
        );
      },
    );
  }
}