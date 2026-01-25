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
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      // This is the white container
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // The Group Header
                          GroupHeaderWidget(
                            group: group,
                            onTap: () => cubit.toggleGroup(group.id),
                          ),

                          // The Habits List (if expanded)
                          if (state.isGroupExpanded(group.id))
                            Column(
                              // Habits are now in a Column
                              children: group.habits.map((habit) {
                                return HabitItemWidget(
                                  key: ValueKey(habit.id),
                                  habit: habit,
                                );
                              }).toList(),
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
        padding: const EdgeInsets.all(12.0),
        child: Text(group.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class HabitItemWidget extends StatelessWidget {
  final HabitEntity habit;

  const HabitItemWidget({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Text(habit.title),
    );
  }
}
