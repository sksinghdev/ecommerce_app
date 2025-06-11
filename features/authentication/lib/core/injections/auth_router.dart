// import 'package:auto_route/auto_route.dart';

// import '../../presentation/page/login_page.dart';

// part 'auth_router.gr.dart';
 

// @AutoRouterConfig()
// class AuthRouter extends _$AuthRouter {
//   @override
//   final List<AutoRoute> routes = [
//     AutoRoute(page: LoginRoute.page),
    
//   ];
// }

// authentication/core/injections/auth_router.dart
import 'package:auto_route/auto_route.dart';
import '../../presentation/page/login_page.dart'; // Ensure correct relative path
import 'package:ecommerce_app/src/application/router/app_router.dart';

// Remove: part 'auth_router.gr.dart'; // No longer needed
// Remove: @AutoRouterConfig()
// Remove: extends _$AuthRouter

class AuthRouter { // This is now a simple class that provides a list of routes
  final List<AutoRoute> routes = [
    AutoRoute(page: LoginRoute.page, path: '/login'), // Added a path for clarity
    // You can add more authentication routes here, e.g.,
    // AutoRoute(page: RegisterRoute.page, path: '/register'),
  ];
}
