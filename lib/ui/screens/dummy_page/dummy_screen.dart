import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DummyScreenProvider extends StatelessWidget {
  const DummyScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const DummyScreen();
  }
}

class DummyScreen extends StatelessWidget {
  const DummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Text('dummy'),));
  }
}

