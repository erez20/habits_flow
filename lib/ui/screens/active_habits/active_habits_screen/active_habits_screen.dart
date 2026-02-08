import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:habits_flow/ui/screens/active_habits/app_bar/app_bar_builder.dart';
import 'package:habits_flow/ui/widgets/all_groups/all_groups_provider.dart';
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
      body: Stack(
        children: [

          BlocBuilder<ActiveHabitsScreenCubit, ActiveHabitsScreenState>(
            buildWhen: (previous, current) => previous.uiModel != current.uiModel,
            builder: (context, state) {

              var isDisabled = state.uiModel != null;
              return IgnorePointer(
                ignoring: isDisabled,
                child: ColorFiltered(
                  colorFilter: isDisabled
                      ? ColorFilter.mode(Colors.grey.withValues(alpha: 0.6), BlendMode.srcATop)
                      : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                  child: SafeArea(
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
              );
            },
          ),
        ],
      ),
    );
  }
}

