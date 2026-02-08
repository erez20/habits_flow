import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'package:habits_flow/ui/widgets/new_habit_form/new_habit_form_provider.dart';
import 'package:habits_flow/ui/ui_models/new_habit_form_ui_model.dart';

import 'create_habit_cubit.dart';

class CreateHabitWidget extends StatelessWidget {
  const CreateHabitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateHabitCubit>();
    final habitsSep = Constants.habitsSep;
    final size = Constants.habitSide(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: habitsSep, vertical: habitsSep),
      child: InkWell(
        onTap: () => _addHabitModal(
          context: context,
          onConfirm: ({required uiModel}) => cubit.addHabit(uiModel: uiModel),
        ),
        child: (Container(
          height: size,
          width: size,
          color: Colors.orange,
        )),
      ),
    );
  }

  void _addHabitModal({
    required BuildContext context,
    required void Function({required NewHabitFormUiModel uiModel}) onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.blueGrey[100],
      builder: (_) => NewHabitFormProvider(onConfirm: onConfirm,
      ),
    );
  }
}
