import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart';
import 'package:habits_flow/injection.dart';
import 'active_habits_screen_cubit.dart';
import 'active_habits_screen.dart';

class ActiveHabitsScreenProvider extends StatelessWidget {
  const ActiveHabitsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActiveHabitsScreenCubit(addGroupUseCase: getIt<AddGroupUseCase>()),
      child: const ActiveHabitsScreen(),
    );
  }
}
