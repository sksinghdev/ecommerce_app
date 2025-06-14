// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:cart_detail/presentation/pages/cart_details.dart' as _i1;
import 'package:cart_detail/presentation/pages/order_success.dart' as _i2;
import 'package:flutter/material.dart' as _i4;
import 'package:product_listing/domain/entity/product.dart' as _i5;

/// generated route for
/// [_i1.CartDetails]
class CartDetails extends _i3.PageRouteInfo<CartDetailsArgs> {
  CartDetails({
    _i4.Key? key,
    required List<_i5.Product> products,
    List<_i3.PageRouteInfo>? children,
  }) : super(
          CartDetails.name,
          args: CartDetailsArgs(
            key: key,
            products: products,
          ),
          initialChildren: children,
        );

  static const String name = 'CartDetails';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CartDetailsArgs>();
      return _i1.CartDetails(
        key: args.key,
        products: args.products,
      );
    },
  );
}

class CartDetailsArgs {
  const CartDetailsArgs({
    this.key,
    required this.products,
  });

  final _i4.Key? key;

  final List<_i5.Product> products;

  @override
  String toString() {
    return 'CartDetailsArgs{key: $key, products: $products}';
  }
}

/// generated route for
/// [_i2.OrderSuccessScreen]
class OrderSuccessRoute extends _i3.PageRouteInfo<OrderSuccessRouteArgs> {
  OrderSuccessRoute({
    _i4.Key? key,
    required List<_i5.Product> products,
    required String orderId,
    required String paymentMethod,
    required DateTime deliveryDate,
    List<_i3.PageRouteInfo>? children,
  }) : super(
          OrderSuccessRoute.name,
          args: OrderSuccessRouteArgs(
            key: key,
            products: products,
            orderId: orderId,
            paymentMethod: paymentMethod,
            deliveryDate: deliveryDate,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderSuccessRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderSuccessRouteArgs>();
      return _i2.OrderSuccessScreen(
        key: args.key,
        products: args.products,
        orderId: args.orderId,
        paymentMethod: args.paymentMethod,
        deliveryDate: args.deliveryDate,
      );
    },
  );
}

class OrderSuccessRouteArgs {
  const OrderSuccessRouteArgs({
    this.key,
    required this.products,
    required this.orderId,
    required this.paymentMethod,
    required this.deliveryDate,
  });

  final _i4.Key? key;

  final List<_i5.Product> products;

  final String orderId;

  final String paymentMethod;

  final DateTime deliveryDate;

  @override
  String toString() {
    return 'OrderSuccessRouteArgs{key: $key, products: $products, orderId: $orderId, paymentMethod: $paymentMethod, deliveryDate: $deliveryDate}';
  }
}
