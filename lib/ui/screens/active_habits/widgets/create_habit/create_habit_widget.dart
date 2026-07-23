import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/theme/app_colors.dart';
import 'package:habits_flow/ui/constants/constants.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/group_ui.dart';
import 'package:habits_flow/ui/screens/active_habits/dialogs/new_habit_form_dialog/new_habit_form_dialog.dart';

import 'create_habit_cubit.dart';

class CreateHabitWidget extends StatelessWidget {
  final GroupUI groupUI;
  const CreateHabitWidget({super.key, required this.groupUI});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateHabitCubit>();
    final size = Constants.habitSide(context);
    return InkWell(
      onTap: () => NewHabitFormDialog.show(
        context,
        onConfirm: cubit.addHabit,
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

}
