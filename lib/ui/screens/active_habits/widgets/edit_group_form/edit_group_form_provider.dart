import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/selected_group_ui.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';

import 'edit_group_form_cubit.dart';
import 'edit_group_form_widget.dart';

class EditGroupFormProvider extends StatelessWidget {
  final GroupUI uiModel;
  final void Function({required SelectedGroupUI uiModel}) onUpdate;

  const EditGroupFormProvider({
    super.key,
    required this.uiModel,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditGroupFormCubit(
        uiModel: uiModel,
        onUpdate: onUpdate,
      ),
      child:  EditGroupFormWidget(
        uiModel: uiModel,
      ),
    );
  }
}
