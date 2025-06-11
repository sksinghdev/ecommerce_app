import 'package:common/common.dart';
import 'package:authentication/presentation/page/login_page.dart';
import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: LoginPage.page, initial: true),
    
  ];
}