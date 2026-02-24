import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';

import 'edit_habit_form_cubit.dart';
import 'edit_habit_form_state.dart';

class EditHabitFormWidget extends StatefulWidget {
  final HabitEntity habit;
  const EditHabitFormWidget({super.key, required this.habit});

  @override
  State<EditHabitFormWidget> createState() => _EditHabitFormWidgetState();
}

class _EditHabitFormWidgetState extends State<EditHabitFormWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditHabitFormCubit, EditHabitFormState>(
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
        final cubit = context.read<EditHabitFormCubit>();

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
                    'title': widget.habit.title,
                    'info': widget.habit.info,
                    'link': widget.habit.link,
                    'points': widget.habit.points,
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
                      _info(),
                      const SizedBox(height: 16),
                      _link(),
                      const SizedBox(height: 16),
                      _points(),
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
      'Edit Habit',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  FormBuilderTextField _title() {
    return FormBuilderTextField(
      name: 'title',
      maxLength: 20,
      focusNode: _titleFocusNode,
      autofocus: false, //for now, no focus request
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
        FormBuilderValidators.maxLength(200, checkNullOrEmpty: false),
      ]),
    );
  }

  FormBuilderDropdown<int> _points() {
    return FormBuilderDropdown<int>(
      name: 'points',
      decoration: InputDecoration(
        labelText: 'Points',
        prefixIcon: const Icon(Icons.star),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: List.generate(20, (index) => index + 1)
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value.toString()),
              ))
          .toList(),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
    );
  }

  SizedBox _submit(EditHabitFormState state, EditHabitFormCubit cubit) {
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
                  cubit.updateForm(_formKey.currentState!.value);
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
        FormBuilderValidators.url(checkNullOrEmpty: false),
      ]),
    );
  }
}
