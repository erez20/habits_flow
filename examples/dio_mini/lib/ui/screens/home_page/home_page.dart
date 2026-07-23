
import 'package:dio_mini/ui/widgets/dash_board/dash_board_provider.dart';
import 'package:dio_mini/ui/widgets/monitor/monitor_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DashBoardProvider(),
          Expanded(

            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, i) => MonitorProvider(id: i),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemCount: 5,
            ),
          ),

        ],
      ),
    );
  }
}
