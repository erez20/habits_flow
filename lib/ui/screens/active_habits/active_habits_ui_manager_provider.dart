import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'active_habits_ui_manager.dart';
import 'active_habits_screen.dart';

class ActiveHabitsUIManagerProvider extends StatelessWidget {
  const ActiveHabitsUIManagerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ActiveHabitsUIManager>(
      create: (context) => ActiveHabitsUIManagerImpl(),
      dispose: (manager) => manager.dispose(),
      child: ActiveHabitsScreen(),
    );
  }
}
