import 'package:flutter/material.dart';
import 'package:product_listing/domain/entity/product.dart';
import '../bloc/cart_cubit.dart';
import 'package:common/common.dart';
import 'package:cart_detail/presentation/bloc/product_list_cubit.dart';

import 'product_card.dart';

class ProductCarousel extends StatelessWidget {
  final int pos;
  final List<Product> products;

  ProductCarousel({
    super.key,
    required this.pos,
    required this.products,
  }) : pageNotifier = ValueNotifier<int>(pos);

  final ValueNotifier<int> pageNotifier;

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: pos);

    return Column(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            controller: controller,
            itemCount: products.length,
            onPageChanged: (index) => pageNotifier.value = index,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                child: ProductCard(
                  product: product,
                  onPressedCart: () {
                    context.read<CartCubit>().addOrRemoveFromCart(product);
                  },
                  onPressedPayment: () {
                    /// need to call payment here
                    ///
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Proceeding to payment...')),
                    );

                    /// TODO: Replace with actual user ID from auth state
                    const int userId = 23;
                    context.read<ProductListCubit>().makePayment(
                          product.price,
                          [product],
                          userId,
                        );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<int>(
          valueListenable: pageNotifier,
          builder: (context, currentPage, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(products.length, (index) {
                final isActive = index == currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: isActive ? 8 : 5,
                  height: isActive ? 8 : 5,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.blue : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}
