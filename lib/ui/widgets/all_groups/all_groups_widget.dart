import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_manager.dart';
import 'package:habits_flow/ui/widgets/all_groups/all_groups_cubit.dart';
import 'package:habits_flow/ui/widgets/group/group_provider.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_provider.dart';

import 'all_groups_state.dart';

class AllGroupsWidget extends StatelessWidget {
  const AllGroupsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AllGroupsCubit>();
    final manager = context.read<ActiveHabitsManager>();

    return Expanded(
      child: BlocBuilder<AllGroupsCubit, AllGroupsState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return _EmptyGroupsWidget();
          } else {
            return _GroupsListWidget(
              state: state,
              cubit: cubit,
              manager: manager,
            );
          }
        },
      ),
    );
  }
}

class _EmptyGroupsWidget extends StatelessWidget {
  const _EmptyGroupsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          "Habits Flow!\nTrack and organize your habits, no matter the frequency. To begin, create your first habit group (+) and start building a better you.",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.normal,
            color: Colors.blueGrey[800],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _GroupsListWidget extends StatelessWidget {
  const _GroupsListWidget({
    super.key,
    required this.state,
    required this.cubit,
    required this.manager,
  });

  final AllGroupsState state;
  final AllGroupsCubit cubit;
  final ActiveHabitsManager manager;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: state.groupList.length,
      onReorder: (oldIndex, newIndex) =>
          cubit.reorderGroups(oldIndex, newIndex),
      proxyDecorator: (child, index, animation) {
        return Material(
          key: ValueKey("dragged_group_${state.groupList[index].id}"),
          elevation: 4.0,
          child: RepositoryProvider.value(
            value: manager,
            child: child,
          ),
        );
      },
      itemBuilder: (context, index) {
        final group = state.groupList[index];
        return Padding(
          key: ValueKey(group.id),
          padding: EdgeInsets.symmetric(
            horizontal: Constants.mainPageHorizontalPadding,
            vertical: 4,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: GroupProvider(
                    group: group,
                    onTap: () => cubit.toggleGroup(group.id),
                  ),
                ),
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
        );
      },
    );
  }
}
