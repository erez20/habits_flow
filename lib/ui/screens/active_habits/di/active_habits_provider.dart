import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/injection.dart';


import '../active_habits_screen/active_habits_screen_provider.dart';
import 'active_habits_manager.dart';

@RoutePage()
class ActiveHabitsProvider extends StatelessWidget {
  const ActiveHabitsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ActiveHabitsManager>(
      create: (context) => getIt<ActiveHabitsManager>(),
      dispose: (manager) => manager.dispose(),
      child: ActiveHabitsScreenProvider(),
    );
  }
}
