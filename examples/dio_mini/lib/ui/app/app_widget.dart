import 'package:dio_mini/ui/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {

  const AppWidget({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(title: 'Fetch data'),
    );
  }
}
