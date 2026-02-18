

import 'package:flutter/material.dart';
import 'package:habits_flow/core/logger/app_logger.dart';
import 'package:habits_flow/injection.dart';
import 'package:habits_flow/ui/routes/app_router.dart';
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initLogger();
  configureDependencies();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

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

