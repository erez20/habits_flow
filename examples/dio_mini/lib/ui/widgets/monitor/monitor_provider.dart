import 'package:dio_mini/injection.dart';
import 'package:dio_mini/logic/repos/user_repo.dart';
import 'package:dio_mini/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'monitor_cubit.dart';
import 'monitor_widget.dart';

class MonitorProvider extends StatelessWidget {
  final int id;

  const MonitorProvider({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var userRepo = getIt<UserRepo>();
        return MonitorCubit(
          id: id,
          userRepo: userRepo,
        );
      },
      child: MonitorWidget(id: id),
    );
  }
}
