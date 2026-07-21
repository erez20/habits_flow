import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';
import 'package:habits_flow/ui/screens/active_habits/widgets/new_habit_form/new_habit_form_provider.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/new_habit_form_ui.dart';

import 'create_habit_cubit.dart';

class CreateHabitWidget extends StatelessWidget {
  final GroupUI groupUI;
  const CreateHabitWidget({super.key, required this.groupUI});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateHabitCubit>();
    final size = Constants.habitSide(context);
    return InkWell(
      onTap: () => _addHabitModal(
        context: context,
        onConfirm: ({required uiModel}) => cubit.addHabit(uiModel: uiModel),
      ),
        child: SizedBox( // Force the filter to these dimensions
          height: size,
          width: size,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.1),
                BlendMode.srcATop
                ,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: groupUI.color[50],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(width: 2.0, color: Colors.grey[500]!)
              ),
              child:  Icon(
                Icons.add,
                color: AppColorsConst.border,
                size: 24.0,
              ),
            ),            ),
        ),
    );
  }

  void _addHabitModal({
    required BuildContext context,
    required void Function({required NewHabitFormUI uiModel}) onConfirm,
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
