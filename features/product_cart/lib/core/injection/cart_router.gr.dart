// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i3;
import 'package:product_cart/presentation/page/product_carts.dart' as _i1;
import 'package:product_listing/domain/entity/product.dart' as _i4;

/// generated route for
/// [_i1.ProductCarts]
class ProductCarts extends _i2.PageRouteInfo<ProductCartsArgs> {
  ProductCarts({
    _i3.Key? key,
    required int pos,
    required List<_i4.Product> products,
    List<_i2.PageRouteInfo>? children,
  }) : super(
          ProductCarts.name,
          args: ProductCartsArgs(
            key: key,
            pos: pos,
            products: products,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductCarts';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductCartsArgs>();
      return _i1.ProductCarts(
        key: args.key,
        pos: args.pos,
        products: args.products,
      );
    },
  );
}

class ProductCartsArgs {
  const ProductCartsArgs({
    this.key,
    required this.pos,
    required this.products,
  });

  final _i3.Key? key;

  final int pos;

  final List<_i4.Product> products;

  @override
  String toString() {
    return 'ProductCartsArgs{key: $key, pos: $pos, products: $products}';
  }
}
