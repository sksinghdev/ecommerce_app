import 'package:flutter/material.dart';
 import 'package:product_listing/domain/entity/product.dart';
import '../bloc/cart_cubit.dart';
import 'package:common/common.dart';

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
          height: 320,
          child: PageView.builder(
            controller: controller,
            itemCount: products.length,
            onPageChanged: (index) => pageNotifier.value = index,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () => context.read<CartCubit>().addOrRemoveFromCart(product),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              product.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('\$${product.price.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 12 : 8,
                  height: isActive ? 12 : 8,
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
