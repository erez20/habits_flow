import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/shared/generate_backup_use_case.dart';
import 'package:habits_flow/domain/use_cases/shared/restore_backup_use_case.dart';
import 'package:habits_flow/injection.dart';
import 'side_menu_cubit.dart';
import 'side_menu_widget.dart';

class SideMenuProvider extends StatelessWidget {
  const SideMenuProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final generateBackupUseCase = getIt<GenerateBackupUseCase>();
    final  restoreBackupUseCase = getIt<RestoreBackupUseCase>();
    return BlocProvider(
      create: (context) => SideMenuCubit(
        generateBackupUseCase: generateBackupUseCase,
        restoreBackupUseCase: restoreBackupUseCase,
      ),
      child: const SideMenuWidget(),
    );
  }
}
