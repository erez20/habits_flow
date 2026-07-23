import 'package:injectable/injectable.dart';
import 'package:habits_flow/core/di/di.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: false,
  asExtension: true,
)
void configureDependencies() => getIt.init();
