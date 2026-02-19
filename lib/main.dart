import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/core/logger/app_logger.dart';
import 'package:habits_flow/main/injection.dart';

import 'app_cubit.dart';
import 'app_state.dart';
import 'main/habits_flow_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initLogger();
  configureDependencies();
  runApp(const AppRestarter());
}

class AppRestarter extends StatefulWidget {
  const AppRestarter({super.key});

  static void restart(BuildContext context) {
    context.findAncestorStateOfType<_AppRestarterState>()!.restart();
  }

  @override
  State<AppRestarter> createState() => _AppRestarterState();
}

class _AppRestarterState extends State<AppRestarter> {
  int _key = 0;

  void restart() {
    setState(() => _key++);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(),
      child: BlocListener<AppCubit, AppState>(
        listener: (context, state) {
          if (state is AppRestarting) {
            setState(() => _key++);
          }
        },
        child: HabitsFlowApp(key: ValueKey(_key)),
      ),
    );
  }
}
