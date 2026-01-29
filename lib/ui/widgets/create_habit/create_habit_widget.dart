import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/common/constants.dart';

import 'create_habit_cubit.dart';

class CreateHabitWidget extends StatelessWidget {
  const CreateHabitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateHabitCubit>();
    final habitsSep = Constants.habitsSep;
    final size = Constants.habitWidth(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: habitsSep, vertical: habitsSep),
      child: InkWell(
        onTap: () =>
            _addHabitModal(context: context, onConfirm: cubit.addHabit),
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
    required void Function() onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (_) => InkWell(
        onTap: onConfirm,
        child: Container(
          height: 100,
          width: 100,
          color: Colors.green,
        ),
      ),
    );
  }
}

