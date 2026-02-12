import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/reset_habit_use_case.dart';
import 'package:habits_flow/domain/use_cases/shared/refresh_all_use_case.dart';
import 'package:habits_flow/injection.dart';
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_manager.dart';
import 'active_habits_screen_cubit.dart';
import 'active_habits_screen.dart';

class ActiveHabitsScreenProvider extends StatelessWidget {
  const ActiveHabitsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final resetHabitUseCase = getIt.get<ResetHabitUseCase>();
        final refreshAllUseCase = getIt.get<RefreshAllUseCase>();
        return ActiveHabitsScreenCubit(
        addGroupUseCase: getIt<AddGroupUseCase>(),
        manager: context.read<ActiveHabitsManager>(),
        resetHabitUseCase: resetHabitUseCase,
          refreshAllUseCase: refreshAllUseCase
      );
      },
      child: const ActiveHabitsScreen(),
    );
  }
}
