import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/ui/widgets/all_groups/all_groups_cubit.dart';

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      // The Group Header (Collapsible)
                      SliverToBoxAdapter(
                        child: GroupHeaderWidget(
                          group: group,
                          onTap: () => cubit.toggleGroup(group.id),
                        ),
                      ),
                      // The Habits List (Only shown if expanded)
                      if (state.isGroupExpanded(group.id))
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final habit = group.habits[index];
                              return HabitItemWidget(
                                key: ValueKey(habit.id),
                                habit: habit,
                              );
                            },
                            childCount: group.habits.length,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class GroupHeaderWidget extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback onTap;

  const GroupHeaderWidget({
    super.key,
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        child: Text(group.title),
      ),
    );
  }
}

class HabitItemWidget extends StatelessWidget {
  final HabitEntity habit;

  const HabitItemWidget({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Container(height: 20, width: 100, child: Text(habit.title));
  }
}
