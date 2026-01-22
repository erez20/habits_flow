import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/widgets/group/group_cubit.dart';
import 'package:habits_flow/ui/widgets/group/group_state.dart';

class GroupWidget extends StatelessWidget {
  const GroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Fimber.d("build: GroupWidget");

    return BlocBuilder<GroupCubit, GroupState>(
      //buildWhen: (previous, current) => previous != current,
      builder: (context, state) {

        Fimber.d("build group widget BlocBuilder: ${state.entity.shortId}");
        return Text("${state.entity}\n");
      },
    );
  }
}
