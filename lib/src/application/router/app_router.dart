import 'package:auto_route/auto_route.dart';
import 'package:authentication/core/injections/auth_router.dart';

import '../../presentation/widgets/splash_screen.dart';
part 'app_router.gr.dart';
 

@AutoRouterConfig()
class AppRouter extends RootStackRouter{
  @override
  final List<AutoRoute> routes = [
    
    AutoRoute(page: SplashRoute.page, initial: true),
    ...AuthRouter().routes,
    
    
  ];
}