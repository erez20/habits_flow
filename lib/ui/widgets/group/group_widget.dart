import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/widgets/group/group_cubit.dart';
import 'package:habits_flow/ui/widgets/group/group_state.dart';

class GroupWidget extends StatelessWidget {
  final VoidCallback onTap;

  const GroupWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Fimber.d("build: GroupWidget");
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        Fimber.d("build group widget BlocBuilder: ${state.entity.shortId}");
        return InkWell(onTap: onTap, child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            state.entity.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
      },
    );
  }
}
