

import 'package:flutter/material.dart';
import 'package:habits_flow/core/logger/app_logger.dart';
import 'package:habits_flow/injection.dart';
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initLogger();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habits Flow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ActiveHabitsProvider(),
    );
  }
}

