import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_group_form_cubit.dart';
import 'new_group_form_state.dart';

class NewGroupFormWidget extends StatelessWidget {
  const NewGroupFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewGroupFormCubit, NewGroupFormState>(
      builder: (context, state) {
        return const Scaffold(
          body: Center(child: Text('NewGroupForm Feature')),
        );
      },
    );
  }
}
