import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_group_form_cubit.dart';
import 'new_group_form_widget.dart';

class NewGroupFormProvider extends StatelessWidget {
  const NewGroupFormProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewGroupFormCubit(),
      child: const NewGroupFormWidget(),
    );
  }
}
