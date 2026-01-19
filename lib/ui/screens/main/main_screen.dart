import 'package:flutter/material.dart';
import 'package:habits_flow/ui/widgets/test_dashboard/test_dashboard_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: TestDashboardProvider(),
    );
  }
}
