import 'package:flutter/material.dart';
import 'package:common/common.dart';
import 'package:product_listing/domain/entity/product.dart';
import 'package:google_fonts/google_fonts.dart';

import 'animated_button.dart';
import 'animated_price_popped.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function() onPressedCart;
  final Function() onPressedPayment;

  const ProductCard({
    super.key,
    required this.product,
    required this.onPressedCart,
    required this.onPressedPayment,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 8),
                  _buildDescription(),
                  const SizedBox(height: 8),
                  _buildCategoryAndPrice(),
                  const SizedBox(height: 8),
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: CachedNetworkImage(
        imageUrl: product.image,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) => const SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (_, __, ___) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      product.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      product.description,
      style: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildCategoryAndPrice() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            product.category,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.green.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        AnimatedPricePopped(price: product.price),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AnimatedActionButton(
            label: 'Add to Cart',
            icon: Icons.shopping_cart,
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 300));
              onPressedCart();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AnimatedActionButton(
            label: 'Buy Now',
            icon: Icons.payment,
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 300));
              onPressedPayment();
            },
          ),
        ),
      ],
    );
  }
}
