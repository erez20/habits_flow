import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/ui_models/edit_group_ui_model.dart';
import 'package:habits_flow/ui/ui_models/group_ui_model.dart';

import 'edit_group_form_cubit.dart';
import 'edit_group_form_widget.dart';

class EditGroupFormProvider extends StatelessWidget {
  final GroupUIModel uiModel;
  final void Function({required SelectedGroupUIModel uiModel}) onUpdate;

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
