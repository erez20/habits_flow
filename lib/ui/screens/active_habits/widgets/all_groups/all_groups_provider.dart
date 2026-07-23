import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:habits_flow/domain/use_cases/group/groups_list_stream_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/reorder_groups_use_case.dart';
import 'package:habits_flow/core/di/di.dart';
import 'package:habits_flow/ui/screens/active_habits/coordinator/active_habits_coordinator.dart';

import 'all_groups_cubit.dart';
import 'all_groups_widget.dart';

class AllGroupsProvider extends StatelessWidget {
  const AllGroupsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final coordinator = context.read<ActiveHabitsCoordinator>();
    return BlocProvider(
      create: (context) {
        var reorderGroupsUseCase = getIt<ReorderGroupsUseCase>();
        return AllGroupsCubit(
        groupsListStreamUseCase: GetIt.I<GroupsListStreamUseCase>(),
        coordinator: coordinator, reorderGroupsUseCase: reorderGroupsUseCase,

      );
      },
      child: AllGroupsWidget(),
    );
  }
}
