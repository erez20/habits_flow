import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/active_habits_screen/active_habits_screen_cubit.dart';

class ActiveHabitsAppBar extends StatelessWidget implements PreferredSizeWidget{
  const ActiveHabitsAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActiveHabitsScreenCubit>();
    return AppBar(
      title: const Text('Active Habits'),
      actions: [
        InkWell(
          child: InkWell(onTap: cubit.addGroup, child: Icon(Icons.add)),
        ),
      ],
    );
  }

  @override

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
