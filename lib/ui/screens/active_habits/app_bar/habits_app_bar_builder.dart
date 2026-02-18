import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/active_habits_screen/active_habits_screen_cubit.dart';
import 'package:habits_flow/ui/screens/active_habits/active_habits_screen/active_habits_screen_state.dart';

import 'active_habits_app_bar.dart';
import 'habit_selected_app_bar.dart';

class HabitsAppBarBuilder extends StatelessWidget implements PreferredSizeWidget {
  const HabitsAppBarBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveHabitsScreenCubit, ActiveHabitsScreenState>(
      buildWhen: (previous, current) => previous.uiModel != current.uiModel,
      builder: (context, state) {
        var uiModel = state.uiModel;
        return uiModel != null
            ? HabitSelectedAppBar(uiModel: uiModel)
            : ActiveHabitsAppBar();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
