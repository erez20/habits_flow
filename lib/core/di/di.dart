import 'package:get_it/get_it.dart';

/// The service-locator handle. Pure: depends only on get_it, so every layer
/// may import it. Registration/wiring lives at the top in main/injection.dart.
final getIt = GetIt.instance;
