import 'package:authentication/core/injections/auth_router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class AuthRouter extends RootStackRouter {
  final List<AutoRoute> routes = [
    AutoRoute(page: LoginRoute.page, path: '/login'),
  ];
}
