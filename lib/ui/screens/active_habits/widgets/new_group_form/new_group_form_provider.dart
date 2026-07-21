import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_group_form_cubit.dart';
import 'package:habits_flow/ui/ui_models/new_group_form_ui.dart';
import 'new_group_form_widget.dart';

class NewGroupFormProvider extends StatelessWidget {
  final void Function({required NewGroupFormUI uiModel}) onConfirm;
  const NewGroupFormProvider({super.key,required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewGroupFormCubit(onConfirm: onConfirm),
      child: const NewGroupFormWidget(),
    );
  }
}
