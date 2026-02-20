import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/use_cases/habit/habits_of_group_stream_use_case.dart';
import 'package:habits_flow/main/injection.dart';
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_manager.dart';



import 'habits_collection_cubit.dart';
import 'habits_collection_widget.dart';

class HabitsCollectionProvider extends StatelessWidget {
  final GroupEntity group;

  const HabitsCollectionProvider({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final habitsOfGroupStreamUseCase = getIt<HabitsOfGroupStreamUseCase>();
        final manager = context.read<ActiveHabitsManager>();
        return HabitsCollectionCubit(
        group: group,
        habitsOfGroupStreamUseCase: habitsOfGroupStreamUseCase,
          manager: manager,
      );
      },
      child: const HabitsCollectionWidget(),
    );
  }
}
