import 'package:auto_route/auto_route.dart';
import 'package:cart_detail/core/injection/cart_details_router.gr.dart';

@AutoRouterConfig()
class CartDetailsRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: CartDetails.page, path: '/cartdetails'),
        AutoRoute(page: OrderSuccessRoute.page, path: '/OrderSuccessRoute'),
      ];
}
