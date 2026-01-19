import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:habits_flow/ui/widgets/test_dashboard/test_dashboard_cubit.dart';
import 'package:habits_flow/ui/widgets/test_dashboard/test_dashboard_widget.dart';

class TestDashboardProvider extends StatelessWidget {
  const TestDashboardProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TestDashboardCubit>(
      create: (context) => GetIt.I<TestDashboardCubit>(), // Use the local getIt instance
      child: const TestDashboardWidget(),
    );
  }
}
