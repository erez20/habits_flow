import 'package:flutter/material.dart';


class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          ListTile(title: Text("Export Data",),),
          // Add other Drawer items here
        ],
      ),
    );
  }
}
