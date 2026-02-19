import 'package:flutter/material.dart';
import 'package:habits_flow/ui/routes/app_router.dart';

class HabitsFlowApp extends StatelessWidget {
  HabitsFlowApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      title: 'Habits Flow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
