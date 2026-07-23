import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/selected_group_ui.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';

import 'edit_group_form_dialog_cubit.dart';
import 'edit_group_form_dialog.dart';

class EditGroupFormDialogProvider extends StatelessWidget {
  final GroupUI uiModel;
  final void Function({required SelectedGroupUI uiModel}) onUpdate;

  const EditGroupFormDialogProvider({
    super.key,
    required this.uiModel,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditGroupFormDialogCubit(
        uiModel: uiModel,
        onUpdate: onUpdate,
      ),
      child:  EditGroupFormDialog(
        uiModel: uiModel,
      ),
    );
  }
}
