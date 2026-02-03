import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_group_form_cubit.dart';
import 'new_group_form_ui_model.dart';
import 'new_group_form_widget.dart';

class NewGroupFormProvider extends StatelessWidget {
  final void Function({required NewGroupFormUIModel uiModel}) onConfirm;
  const NewGroupFormProvider({super.key,required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewGroupFormCubit(onConfirm: onConfirm),
      child: const NewGroupFormWidget(),
    );
  }
}
