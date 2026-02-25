import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_group_form_cubit.dart';
import 'edit_group_form_state.dart';

class EditGroupFormWidget extends StatelessWidget {
  const EditGroupFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditGroupFormCubit, EditGroupFormState>(
      builder: (context, state) {
        return const Scaffold(
          body: Center(child: Text('EditGroupForm Feature')),
        );
      },
    );
  }
}
