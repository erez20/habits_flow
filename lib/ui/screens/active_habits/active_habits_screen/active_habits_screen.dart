import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;
import 'package:habits_flow/ui/screens/active_habits/app_bar/app_bar_builder.dart';
import 'package:habits_flow/ui/widgets/all_groups/all_groups_provider.dart';
import 'package:habits_flow/ui/widgets/common/animated_color_filter/animated_color_filter.dart';
import 'package:habits_flow/ui/widgets/common/joystick/joystick_widget.dart';

import 'active_habits_screen_cubit.dart' show ActiveHabitsScreenCubit;
import 'active_habits_screen_state.dart' show ActiveHabitsScreenState;

class ActiveHabitsScreen extends StatelessWidget {
  const ActiveHabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBarBuilder(),
      body: BlocBuilder<ActiveHabitsScreenCubit, ActiveHabitsScreenState>(
        buildWhen: (previous, current) => previous.uiModel != current.uiModel,
        builder: (context, state) {
          final cubit = context.read<ActiveHabitsScreenCubit>();
          final uiModel = state.uiModel;
          final isDisabled = uiModel != null;
          return SafeArea(
            child: Stack(
              children: [
                IgnorePointer(
                  ignoring: isDisabled,
                  child: AnimatedColorFiltered(
                    isDisabled: isDisabled,
                    color: uiModel?.color??Colors.blue,
                    child: Column(
                      children: [
                        AllGroupsProvider(),
                      ],
                    ),
                  ),
                ),
                if (isDisabled)
                  JoystickWidget(
                    habitId: uiModel.habitId,
                    color: uiModel.color,
                    moveRequest: cubit.moveRequest,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

