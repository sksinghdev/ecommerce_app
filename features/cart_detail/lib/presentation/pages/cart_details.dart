
import 'package:auto_route/auto_route.dart';
import 'package:common/common.dart';
import 'package:product_listing/domain/entity/product.dart';

import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/application/di/injection_container.dart';

import '../block/product_list_cubit.dart';
import '../widgets/product_list_view.dart';

@RoutePage()
class CartDetails extends StatelessWidget {
  const CartDetails({super.key, required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
   return BlocProvider(
     create: (_) => injector<ProductListCubit>(),
      child:   ProductListView(products: products),
    );
  }
}