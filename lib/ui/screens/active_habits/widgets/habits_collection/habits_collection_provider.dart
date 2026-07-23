import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';
import 'package:habits_flow/domain/use_cases/habit/habits_of_group_stream_use_case.dart';
import 'package:habits_flow/core/di/di.dart';
import 'package:habits_flow/ui/screens/active_habits/coordinator/active_habits_coordinator.dart';



import 'habits_collection_cubit.dart';
import 'habits_collection_widget.dart';

class HabitsCollectionProvider extends StatelessWidget {
  final GroupUI group;

  const HabitsCollectionProvider({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final habitsOfGroupStreamUseCase = getIt<HabitsOfGroupStreamUseCase>();
        final coordinator = context.read<ActiveHabitsCoordinator>();
        return HabitsCollectionCubit(
        group: group,
        habitsOfGroupStreamUseCase: habitsOfGroupStreamUseCase,
          coordinator: coordinator,
      );
      },
      child: const HabitsCollectionWidget(),
    );
  }
}
