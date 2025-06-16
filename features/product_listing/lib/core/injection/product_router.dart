import 'package:auto_route/auto_route.dart';
import 'package:product_listing/core/injection/product_router.gr.dart';

@AutoRouterConfig()
class ProductRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ProductsRoute.page, path: '/products'),
        AutoRoute(page: OrderHistory.page, path: '/orderhistory'),
      ];
}
