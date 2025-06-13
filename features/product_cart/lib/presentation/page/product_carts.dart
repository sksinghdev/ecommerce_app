 
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:product_listing/domain/entity/product.dart';
import 'package:common/common.dart';
import '../bloc/cart_cubit.dart';
import '../widgets/animated_cart_button.dart';
import '../widgets/product_carousel.dart';

@RoutePage()
class ProductCarts extends StatelessWidget {
  const ProductCarts({super.key, required this.pos, required this.products});

  final int pos;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => CartCubit(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                          title: const Text('Products'),
                          background: Image.network(
                            'https://picsum.photos/800/300?blur',
                            fit: BoxFit.cover,
                          ),
                        ),
              actions: const [AnimatedCartButton()],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ProductCarousel(pos: pos, products: products),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
