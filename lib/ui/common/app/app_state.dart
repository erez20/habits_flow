
import 'package:flutter/foundation.dart';

@immutable
sealed class AppState {}

class AppReady extends AppState {}

class AppRestarting extends AppState {}