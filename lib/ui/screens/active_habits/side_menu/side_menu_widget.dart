import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/screens/active_habits/side_menu/side_menu_cubit.dart' show SideMenuCubit;


class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SideMenuCubit>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:  [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey[700],
            ),
            child: Text(
              'Habits Flow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),

          ),
          ListTile(title: GestureDetector(onTap: cubit.exportDb,child: Text("Export Data",)),),
          ListTile(title: GestureDetector(onTap: cubit.pickAndRestore,child: Text("Restore Backup",)),),

          //TODO test import export!
        ],
      ),
    );
  }
}
