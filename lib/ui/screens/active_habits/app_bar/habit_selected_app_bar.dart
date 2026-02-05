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
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => cubit.clearSelection(),
      ),
        title: Text(uiModel.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => cubit.resetHabitUseCase,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _handleDelete(context),
          ),
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // void _handleReset(BuildContext context) {
  //
  // }

  void _handleDelete(BuildContext context) {}


}

