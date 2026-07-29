import 'package:fimber/fimber.dart' show Fimber;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';
import 'package:habits_flow/domain/use_cases/group/delete_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/edit_group_use_case.dart';
import 'package:habits_flow/core/di/di.dart';

import 'package:habits_flow/ui/screens/active_habits/coordinator/active_habits_coordinator.dart';

import 'group_cubit.dart';
import 'group_widget.dart';

class GroupProvider extends StatefulWidget {
  final GroupUI group;
  final int index;

  const GroupProvider({
    required this.group,
    required this.index,
    super.key,
  });

  @override
  State<GroupProvider> createState() => _GroupProviderState();
}

class _GroupProviderState extends State<GroupProvider> {
  late final GroupCubit _cubit;

  @override
  void initState() {
    super.initState();
    final deleteGroupUseCase = getIt<DeleteGroupUseCase>();
    final editGroupUseCase = getIt<EditGroupUseCase>();
    final coordinator = context.read<ActiveHabitsCoordinator>();

    _cubit = GroupCubit(
      group: widget.group,
      deleteGroupUseCase: deleteGroupUseCase,
      editGroupUseCase: editGroupUseCase,
      coordinator: coordinator,
    );
    Fimber.d("initState: GroupProvider ${widget.group.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    Fimber.d("build: GroupProvider ${widget.group.toString()}");
    return BlocProvider.value(
      value: _cubit,
      child: GroupWidget(index: widget.index),
    );
  }

  @override
  void didUpdateWidget(GroupProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.group != oldWidget.group) {
      _cubit.updateGroup(widget.group);
    }
  }

  @override
  void dispose() {
    _cubit.close(); // Clean up the stream subscriptions
    super.dispose();
  }
}
