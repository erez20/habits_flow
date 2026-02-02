import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/habit/habits_of_group_stream_use_case.dart';
import 'package:habits_flow/injection.dart';
import 'package:habits_flow/ui/screens/active_habits/active_habits_ui_manager.dart';
import 'package:habits_flow/ui/screens/active_habits/active_habits_ui_manager_provider.dart';

import 'habits_collection_cubit.dart';
import 'habits_collection_widget.dart';

class HabitsCollectionProvider extends StatelessWidget {
  final String groupId;

  const HabitsCollectionProvider({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final habitsOfGroupStreamUseCase = getIt<HabitsOfGroupStreamUseCase>();
        final manager = context.read<ActiveHabitsUIManager>();
        return HabitsCollectionCubit(
        groupId: groupId,
        habitsOfGroupStreamUseCase: habitsOfGroupStreamUseCase,
          manager: manager,
      );
      },
      child: const HabitsCollectionWidget(),
    );
  }
}
