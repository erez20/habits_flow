import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_habit_form_cubit.dart';
import 'new_habit_form_state.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:form_builder_validators/form_builder_validators.dart';

class NewHabitFormWidget extends StatelessWidget {
  NewHabitFormWidget({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewHabitFormCubit, NewHabitFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Success!')));
        }
      },
      builder: (context, state) {
        final cubit = context.read<NewHabitFormCubit>();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                // TITLE FIELD
                FormBuilderTextField(
                  name: 'title',
                  maxLength: 20,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(20),
                  ]),
                ),

                const SizedBox(height: 16),

                // INFO FIELD (Multiline & Hebrew Friendly)
                FormBuilderTextField(
                  name: 'info',
                  maxLength: 200,
                  maxLines: 5,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Information',
                    alignLabelWithHint: true,
                    hintText: 'Enter details (Hebrew supported)...',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(200),
                  ]),
                ),

                const SizedBox(height: 16),

                // LINK FIELD
                FormBuilderTextField(
                  name: 'link',
                  decoration: const InputDecoration(
                      labelText: 'Reference Link'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.url(),
                  ]),
                ),

                const Spacer(),

                // CONFIRM BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        cubit.submitForm(_formKey.currentState!.value);
                      }
                    },
                    child: state.isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}