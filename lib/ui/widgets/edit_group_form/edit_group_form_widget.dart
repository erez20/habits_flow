import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/ui_models/group_ui_model.dart';

import 'edit_group_form_cubit.dart';
import 'edit_group_form_state.dart';

class EditGroupFormWidget extends StatefulWidget {
  final GroupUIModel uiModel;
  const EditGroupFormWidget({super.key, required this.uiModel});

  @override
  State<EditGroupFormWidget> createState() => _EditGroupFormWidgetState();
}

class _EditGroupFormWidgetState extends State<EditGroupFormWidget> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditGroupFormCubit, EditGroupFormState>(
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
        final cubit = context.read<EditGroupFormCubit>();

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
                  initialValue: {
                    'title': widget.uiModel.title,


                  },
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
                      _DurationInSec(formKey: _formKey, uiModel: widget.uiModel),
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

  SizedBox _submit(EditGroupFormState state, EditGroupFormCubit cubit) {
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
            final durationType = formData['duration_type'] as EditGroupDurationType;

            int durationInSeconds;
            switch (durationType) {
              case EditGroupDurationType.months:
                durationInSeconds = durationValue * 30 * 24 * 3600;
                break;
              case EditGroupDurationType.days:
                durationInSeconds = durationValue * 24 * 3600;
                break;
              case EditGroupDurationType.hours:
                durationInSeconds = durationValue * 3600;
                break;
              case EditGroupDurationType.seconds:
                durationInSeconds = durationValue;
                break;
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
      name: 'group_color',
      initialValue: widget.uiModel.color,
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
    required this.formKey, required this.uiModel,
  });

  final GlobalKey<FormBuilderState> formKey;
  final GroupUIModel uiModel;


  @override
  State<_DurationInSec> createState() => _DurationInSecState();
}

class _DurationInSecState extends State<_DurationInSec> {
  late EditGroupDurationType _selectedDuration;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.uiModel.durationType;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SegmentedButton<EditGroupDurationType>(
            segments: const [
              ButtonSegment(
                value: EditGroupDurationType.months,
                label: Text('Months'),
                icon: Icon(Icons.calendar_today),
              ),
              ButtonSegment(
                value: EditGroupDurationType.days,
                label: Text('Days'),
                icon: Icon(Icons.calendar_view_day),
              ),
              ButtonSegment(
                value: EditGroupDurationType.hours,
                label: Text('Hours'),
                icon: Icon(Icons.access_time),
              ),
              if (kDebugMode) ButtonSegment(
                value: EditGroupDurationType.seconds,
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
          initialValue: widget.uiModel.durationValue,
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
              if (_selectedDuration == EditGroupDurationType.hours &&
                  (number < 1 || number > 23)) {
                return 'Hours must be between 1 and 23';
              }
              if ((_selectedDuration == EditGroupDurationType.days ||
                  _selectedDuration == EditGroupDurationType.months ||
                  _selectedDuration == EditGroupDurationType.seconds) &&
                  number < 1) {
                return 'Must be at least 1';
              }
              return null;
            },
          ]),
        ),
        FormBuilderField<EditGroupDurationType>(
          name: 'duration_type',
          builder: (field) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

enum EditGroupDurationType {
  months,
  days,
  hours,
  seconds,
}
