import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/main/injection.dart';


import '../screen/active_habits_screen_provider.dart';
import 'active_habits_coordinator.dart';

@RoutePage()
class ActiveHabitsProvider extends StatelessWidget {
  const ActiveHabitsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ActiveHabitsCoordinator>(
      create: (context) => getIt<ActiveHabitsCoordinator>(),
      dispose: (coordinator) => coordinator.dispose(),
      child: ActiveHabitsScreenProvider(),
    );
  }
}
