import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_group_form_dialog_cubit.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/new_group_form_ui.dart';
import 'new_group_form_dialog.dart';

class NewGroupFormDialogProvider extends StatelessWidget {
  final void Function({required NewGroupFormUI uiModel}) onConfirm;
  const NewGroupFormDialogProvider({super.key,required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewGroupFormDialogCubit(onConfirm: onConfirm),
      child: const NewGroupFormDialog(),
    );
  }
}
