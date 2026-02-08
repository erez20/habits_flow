import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';

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
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
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
                      const SizedBox(height: 16),
                      _durationInSec(),
                      const SizedBox(height: 16),
                      _color(),
                      const SizedBox(height: 32),
                      _submit(state, cubit),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //

  Widget _durationInSec() {
    return FormBuilderField<Map<String, int>>(
      name: 'duration',
      validator: (value) {
        final formState = _formKey.currentState;
        if (formState == null) return null;

        final months =
            int.tryParse(formState.fields['months']?.value ?? '0') ?? 0;
        final days = int.tryParse(formState.fields['days']?.value ?? '0') ?? 0;
        final hours =
            int.tryParse(formState.fields['hours']?.value ?? '0') ?? 0;

        if (months == 0 && days == 0 && hours == 0) {
          return 'You must choose duration';
        }
        return null;
      },
      builder: (FormFieldState<Map<String, int>> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'months',
                    decoration: InputDecoration(
                      labelText: 'Months',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType: TextInputType.number,

                    onChanged: (value) => field.didChange({}),
                    onTap: () {
                      if (_formKey.currentState?.fields['months']?.value ==
                          '0') {
                        _formKey.currentState?.fields['months']?.didChange('');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FormBuilderTextField(
                    name: 'days',
                    decoration: InputDecoration(
                      labelText: 'Days',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType: TextInputType.number,

                    onChanged: (value) => field.didChange({}),
                    onTap: () {
                      if (_formKey.currentState?.fields['days']?.value == '0') {
                        _formKey.currentState?.fields['days']?.didChange('');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FormBuilderTextField(
                    name: 'hours',
                    decoration: InputDecoration(
                      labelText: 'Hours',
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType: TextInputType.number,

                    onChanged: (value) => field.didChange({}),
                    onTap: () {
                      if (_formKey.currentState?.fields['hours']?.value ==
                          '0') {
                        _formKey.currentState?.fields['hours']?.didChange('');
                      }
                    },
                  ),
                ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  //

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
      'Add New Group',
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
                  final formData = _formKey.currentState!.value;
                  final months = int.tryParse(formData['months'] ?? '0') ?? 0;
                  final days = int.tryParse(formData['days'] ?? '0') ?? 0;
                  final hours = int.tryParse(formData['hours'] ?? '0') ?? 0;

                  if (months == 0 && days == 0 && hours == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Please enter a duration (months, days, or hours).',
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                    return;
                  }

                  final durationInSeconds =
                      (months * 30 * 24 * 3600) +
                      (days * 24 * 3600) +
                      (hours * 3600);

                  final updatedFormData = {
                    ...formData,
                    'durationInSec': durationInSeconds,
                  };

                  cubit.submitForm(updatedFormData);
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

  Widget _color() {
    return FormBuilderField<Color>(
      name: 'habit_color',
      initialValue: Colors.red,
      builder: (FormFieldState<Color?> field) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Select Group Color',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            errorText: field.errorText,
          ),
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
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
          ),
        );
      },
    );
  }
}

/**/
