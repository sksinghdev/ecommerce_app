// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:cart_detail/presentation/pages/cart_details.dart' as _i1;
import 'package:flutter/material.dart' as _i3;
import 'package:product_listing/domain/entity/product.dart' as _i4;

/// generated route for
/// [_i1.CartDetails]
class CartDetails extends _i2.PageRouteInfo<CartDetailsArgs> {
  CartDetails({
    _i3.Key? key,
    required List<_i4.Product> products,
    List<_i2.PageRouteInfo>? children,
  }) : super(
          CartDetails.name,
          args: CartDetailsArgs(
            key: key,
            products: products,
          ),
          initialChildren: children,
        );

  static const String name = 'CartDetails';

  static _i2.PageInfo page = _i2.PageInfo(
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

  final _i3.Key? key;

  final List<_i4.Product> products;

  @override
  String toString() {
    return 'CartDetailsArgs{key: $key, products: $products}';
  }
}
