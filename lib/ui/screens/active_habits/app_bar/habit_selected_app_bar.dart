import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/active_habits_screen/active_habits_screen_cubit.dart';
import 'package:habits_flow/ui/ui_models/selected_habit_ui_model.dart';

class HabitSelectedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final SelectedHabitUiModel uiModel;

  const HabitSelectedAppBar({
    super.key,
    required this.uiModel,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActiveHabitsScreenCubit>();
    final accent = uiModel.color[700];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => cubit.clearSelection(),
      child: AppBar(
        backgroundColor: Colors.white,
        actionsPadding: EdgeInsets.symmetric(horizontal: 16),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: accent,
          ),
          onPressed: () => cubit.clearSelection(),
        ),
        title: Text(
          uiModel.title,
          style: TextStyle(color: accent),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.restore, color: accent),
            onPressed: cubit.resetHabit,
          ),
          IconButton(
            icon: Icon(Icons.delete_outlined, color: accent),
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

  void _handleDelete({
    required BuildContext context,
    required void Function(String habitId) deleteHabit,
    required SelectedHabitUiModel uiModel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("delete habit?"),
          content: Text(
            "Are you sure you want to delete ${uiModel.title}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteHabit(uiModel.habitId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
