import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:habits_flow/domain/use_cases/habit/habits_of_group_stream_use_case.dart';

import 'habits_collection_cubit.dart';
import 'habits_collection_widget.dart';

class HabitsCollectionProvider extends StatelessWidget {
  final String groupId;

  const HabitsCollectionProvider({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabitsCollectionCubit(
        groupId: groupId,
        habitsOfGroupStreamUseCase: GetIt.I<HabitsOfGroupStreamUseCase>(),
      ),
      child: const HabitsCollectionWidget(),
    );
  }
}
