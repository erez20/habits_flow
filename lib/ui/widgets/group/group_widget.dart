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

        return Container(
          color: state.uiModel.color[50],
          child: InkWell(onTap: onTap, child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              state.uiModel.title,
              style: const TextStyle(
                fontFamily: 'LondrinaOutline',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          )),
        );
      },
    );
  }
}
