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

class _GroupsListWidget extends StatefulWidget {
  const _GroupsListWidget({
    required this.state,
    required this.cubit,
    required this.manager,
  });

  final AllGroupsState state;
  final AllGroupsCubit cubit;
  final ActiveHabitsManager manager;

  @override
  State<_GroupsListWidget> createState() => _GroupsListWidgetState();
}

class _GroupsListWidgetState extends State<_GroupsListWidget> {
  final Map<String, GlobalKey> _groupKeys = {};

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllGroupsCubit, AllGroupsState>(
      listener: (context, state) {
        if (state.groupJustToggled != null) {
          final groupId = state.groupJustToggled!;
          if (state.expandedGroupIds.contains(groupId)) {
            final key = _groupKeys[groupId];
            if (key != null) {
              // Wait for the animation to finish
              Future.delayed(const Duration(milliseconds: 170), () {
                final context = key.currentContext;
                if (context != null) {
                  Scrollable.ensureVisible(
                    context,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: 0.1,
                  );
                }
                widget.cubit.groupExpansionScrolled();
              });
            }
          }
        }
      },
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        itemCount: widget.state.groupList.length + 1, // +1 for padding
        onReorder: (oldIndex, newIndex) {
          // Adjust index for padding
          if (newIndex > widget.state.groupList.length) {
            newIndex = widget.state.groupList.length;
          }
          widget.cubit.reorderGroups(oldIndex, newIndex);
        },
        proxyDecorator: (child, index, animation) {
          return Material(
            key: ValueKey("dragged_group_${widget.state.groupList[index].id}"),
            elevation: 4.0,
            child: RepositoryProvider.value(
              value: widget.manager,
              child: child,
            ),
          );
        },
        itemBuilder: (context, index) {
          // Add padding at the end
          if (index == widget.state.groupList.length) {
            return const SizedBox(
              key: ValueKey('bottom_padding'),
              height: 16,
            );
          }

          final group = widget.state.groupList[index];
          _groupKeys.putIfAbsent(group.id, () => GlobalKey());
          return Padding(
            key: _groupKeys[group.id],
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
                  GroupProvider(
                    group: group,
                    onTap: () => widget.cubit.toggleGroup(group.id),
                    index: index,
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
                    child: widget.state.expandedGroupIds.contains(group.id)
                        ? HabitsCollectionProvider(group: group)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
