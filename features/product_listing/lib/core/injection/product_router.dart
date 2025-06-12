
 import 'package:auto_route/auto_route.dart';
import 'package:product_listing/presentation/page/products_page.dart';
part 'product_router.gr.dart';

@AutoRouterConfig()
class ProductRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ProductsRoute.page, path: '/products'),
      ];
}

