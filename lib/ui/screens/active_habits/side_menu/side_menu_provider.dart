import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'side_menu_cubit.dart';
import 'side_menu_widget.dart';

class SideMenuProvider extends StatelessWidget {
  const SideMenuProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SideMenuCubit(),
      child: const SideMenuWidget(),
    );
  }
}
