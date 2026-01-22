import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/widgets/all_groups/all_groups_cubit.dart';
import 'package:habits_flow/ui/widgets/group/group_widget.dart';

import 'all_groups_state.dart';

class AllGroupsWidget extends StatelessWidget {
  const AllGroupsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<AllGroupsCubit, AllGroupsState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.groupList.length,
            itemBuilder: (context, i) {
              // Access the item directly using 'i'
              final group = state.groupList[i];
              return GroupWidget(entity: group);
            },
          );
        },
      ),
    );
  }
}

