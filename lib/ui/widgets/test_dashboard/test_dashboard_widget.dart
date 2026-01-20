import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'test_dashboard_cubit.dart';

class TestDashboardWidget extends StatelessWidget {
  const TestDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TestDashboardCubit>();

    return Row(
      children: [
        TextButton(onPressed: cubit.addGroup, child: Text("Add G")),
        TextButton(onPressed: cubit.pressTwo, child: Text("2")),
      ],
    );
  }
}
