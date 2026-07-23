import 'package:dio_mini/injection.dart';
import 'package:dio_mini/logic/use_cases/user/get_user_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dash_board_cubit.dart';
import 'dash_board_widget.dart';

class DashBoardProvider extends StatelessWidget {
  const DashBoardProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashBoardCubit(
        useCase: getIt<GetUserUseCase>(),
      ),
      child: DashBoardWidget(maxId: 5),
    );
  }
}
