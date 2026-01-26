import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

import 'habits_collection_cubit.dart';
import 'habits_collection_widget.dart';

class HabitsCollectionProvider extends StatelessWidget {
  final String groupId;
  const HabitsCollectionProvider({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabitsCollectionCubit(groupId: groupId),
      child: const HabitsCollectionWidget(),
    );
  }
}

