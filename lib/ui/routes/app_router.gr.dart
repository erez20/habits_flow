// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_provider.dart'
    as _i1;
import 'package:habits_flow/ui/screens/dummy_page/dummy_screen.dart' as _i2;

/// generated route for
/// [_i1.ActiveHabitsProvider]
class ActiveHabitsProviderRoute extends _i3.PageRouteInfo<void> {
  const ActiveHabitsProviderRoute({List<_i3.PageRouteInfo>? children})
    : super(ActiveHabitsProviderRoute.name, initialChildren: children);

  static const String name = 'ActiveHabitsProviderRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.ActiveHabitsProvider();
    },
  );
}

/// generated route for
/// [_i2.DummyScreenProvider]
class DummyScreenProviderRoute extends _i3.PageRouteInfo<void> {
  const DummyScreenProviderRoute({List<_i3.PageRouteInfo>? children})
    : super(DummyScreenProviderRoute.name, initialChildren: children);

  static const String name = 'DummyScreenProviderRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.DummyScreenProvider();
    },
  );
}
