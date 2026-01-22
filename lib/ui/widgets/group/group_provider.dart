import 'package:fimber/fimber.dart' show Fimber;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

import 'group_cubit.dart';
import 'group_widget.dart';

class GroupProvider extends StatefulWidget {
  final GroupEntity entity;

  const GroupProvider({
    required this.entity,
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
    _cubit = GroupCubit(entity: widget.entity);
  }

  @override
  Widget build(BuildContext context) {
    Fimber.d("build: GroupProvider ${widget.entity.toString()}");
    return BlocProvider.value(
      value: _cubit,
      child: const GroupWidget(),
    );
  }

  @override
  void didUpdateWidget(GroupProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entity != oldWidget.entity) {
      _cubit.updateEntity(widget.entity);
    }
  }

  @override
  void dispose() {
    _cubit.close(); // Clean up the stream subscriptions
    super.dispose();
  }
}
