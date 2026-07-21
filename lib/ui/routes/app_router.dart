import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';


@AutoRouterConfig(replaceInRouteName:'')
class AppRouter extends RootStackRouter {

  @override
  RouteType get defaultRouteType => RouteType.material(); //.cupertino

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ActiveHabitsProviderRoute.page, initial: true),  ];
}
