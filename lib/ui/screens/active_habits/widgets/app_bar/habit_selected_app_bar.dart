import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/dialogs/confirm_dialog/confirm_dialog.dart';
import 'package:habits_flow/ui/screens/active_habits/dialogs/edit_habit_form_dialog/edit_habit_form_dialog.dart';
import 'package:habits_flow/ui/screens/active_habits/dialogs/habit_info_dialog/habit_info_dialog.dart';
import 'package:habits_flow/ui/screens/active_habits/screen/active_habits_screen_cubit.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/selected_habit_ui.dart';

class HabitSelectedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final SelectedHabitUI uiModel;

  const HabitSelectedAppBar({
    super.key,
    required this.uiModel,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActiveHabitsScreenCubit>();
    final accent = uiModel.color[900];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => cubit.clearSelection(),
      child: AppBar(
        backgroundColor: Colors.white,
        actionsPadding: EdgeInsets.symmetric(horizontal: 16),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: accent,
            size: 32,
          ),
          onPressed: () => cubit.clearSelection(),
        ),
        title: Text(
          uiModel.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: accent, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.restore,
              color: accent,
              size: 24,
            ),
            onPressed: cubit.resetHabit,
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: accent,
              size: 24,
            ),
            onPressed: () => EditHabitFormDialog.show(
              context,
              uiModel: uiModel,
              onUpdate: cubit.updateHabit,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: accent,
              size: 24,
            ),
            onPressed: () => HabitInfoDialog.show(
              context,
              uiModel: uiModel,
              onLinkTapped: cubit.onLinkTapped,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outlined,
              color: accent,
              size: 24,
            ),
            onPressed: () => _handleDelete(
              context: context,
              deleteHabit: cubit.deleteHabit,
              uiModel: uiModel,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _handleDelete({
    required BuildContext context,
    required void Function(String habitId) deleteHabit,
    required SelectedHabitUI uiModel,
  }) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Habit',
      message: 'Are you sure you want to delete ${uiModel.title}?',
      confirmLabel: 'Delete',
    );
    if (confirmed) deleteHabit(uiModel.id);
  }
}
