import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_group_form_cubit.dart';
import 'edit_group_form_widget.dart';

class EditGroupFormProvider extends StatelessWidget {
  const EditGroupFormProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditGroupFormCubit(),
      child: const EditGroupFormWidget(),
    );
  }
}
