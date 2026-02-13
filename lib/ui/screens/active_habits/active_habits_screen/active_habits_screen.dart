import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:habits_flow/ui/screens/active_habits/app_bar/app_bar_builder.dart';
import 'package:habits_flow/ui/widgets/all_groups/all_groups_provider.dart';
import 'package:habits_flow/ui/widgets/common/animated_color_filter/animated_color_filter.dart';
import 'package:habits_flow/ui/widgets/test_dashboard/test_dashboard_provider.dart';

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
          var isDisabled = state.uiModel != null;
          return SafeArea(
            child: Stack(
              children: [
                IgnorePointer(
                  ignoring: isDisabled,
                  child: AnimatedColorFiltered(
                    isDisabled: isDisabled,
                    child: Column(
                      children: [
                        AllGroupsProvider(),
                        Container(
                          height: 130,
                          color: Colors.red,
                          child: TestDashboardProvider(),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isDisabled) JoystickWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class JoystickWidget extends StatelessWidget {
  const JoystickWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Icon(Icons.keyboard_arrow_up_rounded, size: 80),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.keyboard_arrow_right_rounded, size: 80),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 80),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.keyboard_arrow_left_rounded, size: 80),
        ),
      ],
    );
  }
}
