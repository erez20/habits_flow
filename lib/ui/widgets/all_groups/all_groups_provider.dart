import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:habits_flow/domain/use_cases/group/groups_list_stream_use_case.dart';

import 'all_groups_cubit.dart';
import 'all_groups_widget.dart';

class AllGroupsProvider extends StatelessWidget {
  const AllGroupsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllGroupsCubit(groupsListStreamUseCase: GetIt.I<GroupsListStreamUseCase>()),
      child: AllGroupsWidget(),
    );
  }
}
