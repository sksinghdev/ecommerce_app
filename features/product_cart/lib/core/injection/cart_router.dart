import 'package:auto_route/auto_route.dart';
import 'package:product_cart/core/injection/cart_router.gr.dart';


 
@AutoRouterConfig()
class CartRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ProductCarts.page, path: '/carts'),
      ];
}
