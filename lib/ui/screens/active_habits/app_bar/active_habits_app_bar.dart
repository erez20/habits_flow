import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/active_habits_screen/active_habits_screen_cubit.dart';
import 'package:habits_flow/ui/widgets/new_group_form/new_group_form_provider.dart';
import 'package:habits_flow/ui/widgets/new_group_form/new_group_form_ui_model.dart';

class ActiveHabitsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ActiveHabitsAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActiveHabitsScreenCubit>();
    return AppBar(
      title: const Text('Active Habits'),
      actions: [
        InkWell(
          child: InkWell(
            onTap: () => _addGroupModal(
              context: context,
              onConfirm: ({required uiModel}) => cubit.addGroup(uiModel: uiModel),
            ),
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _addGroupModal({
    required BuildContext context,
    required void Function({required NewGroupFormUIModel uiModel}) onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.blueGrey[100],

      builder: (_) => NewGroupFormProvider(
        onConfirm: onConfirm,
      ),
    );
  }


}

