
import 'package:auto_route/auto_route.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/application/di/injection_container.dart';

import '../bloc/product_cubit.dart';
import '../widgets/product_list_widget.dart';


@RoutePage()
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<ProductCubit>()..fetchInitialProducts(),
      child:   ProductListPage(),
    );
  }
}