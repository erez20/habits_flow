import 'package:flutter/foundation.dart';
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
                      _DurationInSec(formKey: _formKey),
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
                  final durationValue =
                      int.tryParse(formData['duration_value'] ?? '0') ?? 0;
                  final durationType = formData['duration_type'] as DurationType;

                  int durationInSeconds = 0;
                  if (durationType == DurationType.months) {
                    durationInSeconds = durationValue * 30 * 24 * 3600;
                  } else if (durationType == DurationType.days) {
                    durationInSeconds = durationValue * 24 * 3600;
                  } else if (durationType == DurationType.hours) {
                    durationInSeconds = durationValue * 3600;
                  } else if (durationType == DurationType.seconds) {
                    durationInSeconds = durationValue;
                  }

                  if (durationInSeconds == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Please enter a valid duration.',
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                    return;
                  }

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

class _DurationInSec extends StatefulWidget {
  const _DurationInSec({
    required this.formKey,
  });

  final GlobalKey<FormBuilderState> formKey;

  @override
  State<_DurationInSec> createState() => _DurationInSecState();
}

class _DurationInSecState extends State<_DurationInSec> {
  DurationType _selectedDuration = DurationType.days;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SegmentedButton<DurationType>(
            segments: const [
              ButtonSegment(
                value: DurationType.months,
                label: Text('Months'),
                icon: Icon(Icons.calendar_today),
              ),
              ButtonSegment(
                value: DurationType.days,
                label: Text('Days'),
                icon: Icon(Icons.calendar_view_day),
              ),
              ButtonSegment(
                value: DurationType.hours,
                label: Text('Hours'),
                icon: Icon(Icons.access_time),
              ),
              if (kDebugMode) ButtonSegment(
                value: DurationType.seconds,
                label: Text('Seconds'),
                icon: Icon(Icons.timer),
              ),
            ],
            selected: {_selectedDuration},
            onSelectionChanged: (newSelection) {
              setState(() {
                _selectedDuration = newSelection.first;
                widget.formKey.currentState?.fields['duration_value']
                    ?.didChange(null);
                widget.formKey.currentState?.fields['duration_type']
                    ?.didChange(_selectedDuration);
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        FormBuilderTextField(
          name: 'duration_value',
          decoration: InputDecoration(
            labelText: 'Duration (${_selectedDuration.name})',
            prefixIcon: const Icon(Icons.timelapse),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          keyboardType: TextInputType.number,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
            (value) {
              if (value == null) return null;
              final number = int.tryParse(value);
              if (number == null) return 'Invalid number';
              if (_selectedDuration == DurationType.hours &&
                  (number < 1 || number > 23)) {
                return 'Hours must be between 1 and 23';
              }
              if ((_selectedDuration == DurationType.days ||
                      _selectedDuration == DurationType.months ||
                      _selectedDuration == DurationType.seconds) &&
                  number < 1) {
                return 'Must be at least 1';
              }
              return null;
            },
          ]),
        ),
        FormBuilderField<DurationType>(
          name: 'duration_type',
          initialValue: _selectedDuration,
          builder: (field) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

enum DurationType {
  months,
  days,
  hours,
  seconds,
}
