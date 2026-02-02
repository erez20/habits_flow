import 'package:flutter/material.dart';
import 'package:habits_flow/ui/widgets/all_groups/all_groups_provider.dart';
import 'package:habits_flow/ui/widgets/test_dashboard/test_dashboard_provider.dart';

class ActiveHabitsScreen extends StatelessWidget {
  const ActiveHabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            color: Colors.red[100],
            child: TestDashboardProvider(),
          ),

             AllGroupsProvider(),

        ],
      ),
    );
  }
}
