import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'active_habits_manager.dart';
import 'active_habits_screen.dart';

class ActiveHabitsProvider extends StatelessWidget {
  const ActiveHabitsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ActiveHabitsManager>(
      create: (context) => ActiveHabitsManagerImpl(),
      dispose: (manager) => manager.dispose(),
      child: ActiveHabitsScreen(),
    );
  }
}
