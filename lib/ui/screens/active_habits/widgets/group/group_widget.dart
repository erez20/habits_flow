import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/common/duration/duration_utils.dart';
import 'package:habits_flow/ui/dialogs/confirm_dialog/confirm_dialog.dart';
import 'package:habits_flow/ui/screens/active_habits/dialogs/edit_group_form_dialog/edit_group_form_dialog.dart';
import 'group_cubit.dart';
import 'group_state.dart';

class GroupWidget extends StatelessWidget {
  final VoidCallback onTap;
  final int index;

  const GroupWidget({
    super.key,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    Fimber.d("build: GroupWidget");
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        final cubit = context.read<GroupCubit>();
        var uiModel = state.uiModel;
        return SizedBox(
          height: 60,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 8,
                bottom: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        uiModel.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827), // Light mode
                        ),
                      ),
                      Text(
                        " ${uiModel.durationInSec.toFormattedDuration()}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6B7280), // Light mode
                        ),
                      ),
                      Text(
                        " ${uiModel.completedHabits}/${uiModel.habitsCount}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6B7280), // Light mode
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                      Text(
                        " ${uiModel.points}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6B7280), // Light mode
                        ),
                      ),

                      Expanded(child: SizedBox()),
                      InkWell(
                        child: Icon(
                          Icons.edit,
                          color: Color(0xFF111827),
                          size: 24,
                        ),
                        onTap: () => EditGroupFormDialog.show(
                          context,
                          uiModel: uiModel,
                          onUpdate: cubit.editGroup,
                        ),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        child: Icon(
                          Icons.delete_outlined,
                          color: Color(0xFF111827),
                          size: 24,
                        ),
                        onTap: () => _handleDelete(context, cubit.deleteGroup),
                      ),
                      SizedBox(width: 8),
                      ReorderableDragStartListener(
                        index: index,
                        child: Icon(
                          Icons.drag_handle,
                          color: Color(0xFF111827),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    backgroundColor: uiModel.color[50],
                    color: uiModel.color[700],
                    value: (uiModel.habitsCount != 0)
                        ? uiModel.completedHabits / uiModel.habitsCount
                        : 0,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    void Function() deleteGroup,
  ) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Group',
      message: 'Are you sure you want to delete this group?',
      confirmLabel: 'Delete',
    );
    if (confirmed) deleteGroup();
  }
}
