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
import 'package:reorderables/reorderables.dart';

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
    var cubit = context.read<HabitsCollectionCubit>();
    return BlocBuilder<HabitsCollectionCubit, HabitCollectionState>(
      builder: (context, state) {
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
          child: ReorderableWrap(
            key: _wrapKey,
            alignment: WrapAlignment.start,
            spacing: Constants.habitsSep,
            runSpacing: Constants.habitsSep,
            // This is required for the animation to track items
            onReorder: (oldIndex, newIndex) {
              // Optional: Only if you want to support manual dragging too
             // context.read<HabitBloc>().add(MoveHabitEvent(oldIndex, newIndex));
            },
            children: [
              ...state.habits.map((habit) {
                return MetaData(
                  key: ValueKey(habit.id), // Key MUST be on the direct child of ReorderableWrap
                  behavior: HitTestBehavior.opaque,
                  metaData: habit,
                  child: HabitProvider(
                    habit: habit,
                  ),
                );
              }),
              // The "Create" button stays at the end; ReorderableWrap handles static children well
              CreateHabitProvider(
                key: const ValueKey('create_button'),
                groupUIModel: GroupUIModel.fromEntity(state.group),
              ),
            ],
          ),
        ),);
      },
    );
  }
}
