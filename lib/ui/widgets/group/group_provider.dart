import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

import 'group_cubit.dart';
import 'group_widget.dart';

class GroupProvider extends StatelessWidget {
  final GroupEntity entity;

  const GroupProvider({
    required this.entity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupCubit(entity: entity),
      child: GroupWidget(entity: entity),
    );
  }
}
