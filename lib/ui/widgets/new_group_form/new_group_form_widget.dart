import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'new_group_form_cubit.dart';
import 'new_group_form_state.dart';

class NewGroupFormWidget extends StatefulWidget {
  const NewGroupFormWidget({super.key});

  @override
  State<NewGroupFormWidget> createState() => _NewGroupFormWidgetState();
}

class _NewGroupFormWidgetState extends State<NewGroupFormWidget> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewGroupFormCubit, NewGroupFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Habit created successfully!')),
          );
        }
        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<NewGroupFormCubit>();

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _handle(),
                    const SizedBox(height: 16),
                    _formTitle(context),
                    const SizedBox(height: 24),
                    _title(),
                    const SizedBox(height: 32),
                    _submit(state, cubit),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _handle() {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          backgroundBlendMode: BlendMode.modulate,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Text _formTitle(BuildContext context) {
    return Text(
      'Add New Habit',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  FormBuilderTextField _title() {
    return FormBuilderTextField(
      name: 'title',
      maxLength: 20,
      decoration: InputDecoration(
        labelText: 'Title',
        prefixIcon: Icon(Icons.title),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.maxLength(20),
      ]),
    );
  }

  FormBuilderTextField _info() {
    return FormBuilderTextField(
      name: 'info',
      maxLength: 200,
      maxLines: 5,
      minLines: 3,
      keyboardType: TextInputType.multiline,

      decoration: InputDecoration(
        labelText: 'Information',
        prefixIcon: Icon(Icons.info_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignLabelWithHint: false,
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.maxLength(200),
      ]),
    );
  }

  SizedBox _submit(NewGroupFormState state, NewGroupFormCubit cubit) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.blueGrey[800],

          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: state.isSubmitting
            ? null
            : () {
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            cubit.submitForm(_formKey.currentState!.value);
          }
        },
        child: state.isSubmitting
            ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(
            Colors.white,
          ),
        )
            : const Text('Confirm'),
      ),
    );
  }

  FormBuilderTextField _link() {
    return FormBuilderTextField(
      name: 'link',
      decoration: InputDecoration(
        labelText: 'Reference Link',
        prefixIcon: Icon(Icons.link),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.url(),
      ]),
    );
  }
}

/*
FormBuilderField<Color>(
  name: 'habit_color',
  initialValue: Colors.blue,
  builder: (FormFieldState<Color?> field) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Select Habit Color',
        errorText: field.errorText,
      ),
      child: Wrap(
        spacing: 8,
        children: AppColors.palette.map((materialColor) {
          return GestureDetector(
            onTap: () => field.didChange(materialColor),
            child: CircleAvatar(
              backgroundColor: materialColor,
              child: field.value == materialColor
                ? const Icon(Icons.check, color: Colors.white)
                : null,
            ),
          );
        }).toList(),
      ),
    );
  },
)
 */