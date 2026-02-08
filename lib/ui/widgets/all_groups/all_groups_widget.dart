import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'package:habits_flow/ui/widgets/all_groups/all_groups_cubit.dart';
import 'package:habits_flow/ui/widgets/group/group_provider.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_provider.dart';

import 'all_groups_state.dart';

class AllGroupsWidget extends StatelessWidget {
  const AllGroupsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AllGroupsCubit>();
    return Expanded(
      child: BlocBuilder<AllGroupsCubit, AllGroupsState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              for (final group in state.groupList)
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Constants.mainPageHorizontalPadding,
                    vertical: 2,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      // This is the white container
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // The Group Header
                          GroupProvider(
                            group: group,
                            onTap: () => cubit.toggleGroup(group.id),
                          ),

                          // The Habits List (if expanded)
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: child,
                              );
                            },
                            child: state.expandedGroupIds.contains(group.id)
                                ? HabitsCollectionProvider(group: group)
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}



