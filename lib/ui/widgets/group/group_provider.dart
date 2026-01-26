import 'package:fimber/fimber.dart' show Fimber;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

import 'group_cubit.dart';
import 'group_widget.dart';

class GroupProvider extends StatefulWidget {
  final GroupEntity group;
  final VoidCallback onTap;

  const GroupProvider({
    required this.group,
    required this.onTap,
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
    _cubit = GroupCubit(entity: widget.group);
    Fimber.d("initState: GroupProvider ${widget.group.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    Fimber.d("build: GroupProvider ${widget.group.toString()}");
    return BlocProvider.value(
      value: _cubit,
      child: GroupWidget(onTap:widget.onTap),
    );
  }

  @override
  void didUpdateWidget(GroupProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.group != oldWidget.group) {
      _cubit.updateEntity(widget.group);
    }
  }

  @override
  void dispose() {
    _cubit.close(); // Clean up the stream subscriptions
    super.dispose();
  }
}
