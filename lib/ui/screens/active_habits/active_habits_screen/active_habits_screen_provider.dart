import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'active_habits_screen_cubit.dart';
import 'active_habits_screen.dart';

class ActiveHabitsScreenProvider extends StatelessWidget {
  const ActiveHabitsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActiveHabitsScreenCubit(),
      child: const ActiveHabitsScreen(),
    );
  }
}
