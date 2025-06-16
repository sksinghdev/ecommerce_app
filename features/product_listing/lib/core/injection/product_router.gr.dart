// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:product_listing/presentation/page/order_history_page.dart'
    as _i1;
import 'package:product_listing/presentation/page/products_page.dart' as _i2;

/// generated route for
/// [_i1.OrderHistory]
class OrderHistory extends _i3.PageRouteInfo<void> {
  const OrderHistory({List<_i3.PageRouteInfo>? children})
      : super(
          OrderHistory.name,
          initialChildren: children,
        );

  static const String name = 'OrderHistory';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.OrderHistory();
    },
  );
}

/// generated route for
/// [_i2.ProductsPage]
class ProductsRoute extends _i3.PageRouteInfo<void> {
  const ProductsRoute({List<_i3.PageRouteInfo>? children})
      : super(
          ProductsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.ProductsPage();
    },
  );
}
