import 'package:fimber/fimber.dart';

class AppLogger {
  static void init() {
    Fimber.plantTree(DebugTree());
  }
}
