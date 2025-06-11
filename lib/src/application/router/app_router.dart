import 'package:auto_route/auto_route.dart';
import 'package:authentication/core/injections/auth_router.dart';

import '../../presentation/widgets/splash_screen.dart';
import 'package:authentication/presentation/page/login_page.dart';
part 'app_router.gr.dart';
 

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    
    AutoRoute(page: SplashRoute.page, initial: true),
    ...AuthRouter().routes,
    
    
  ];
}