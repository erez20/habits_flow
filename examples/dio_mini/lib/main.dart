import 'package:dio_mini/ui/app/app_widget.dart';
import 'package:flutter/material.dart';

import 'injection.dart';



Future<void> main() async {
  configureDependencies();
  runApp(const AppWidget());
}

