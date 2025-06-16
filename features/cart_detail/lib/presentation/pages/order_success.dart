import 'package:product_listing/domain/entity/product.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class OrderSuccessScreen extends StatelessWidget {
  final List<Product> products;
  final String orderId;
  final String paymentMethod;
  final DateTime deliveryDate;

  const OrderSuccessScreen({
    super.key,
    required this.products,
    required this.orderId,
    required this.paymentMethod,
    required this.deliveryDate,
  });

  @override
  Widget build(BuildContext context) {
    final total = products.fold<double>(0, (sum, p) => sum + p.price);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Text(
          'Order Placed',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.green, size: 80),
            const SizedBox(height: 12),
            Text(
              'Your order was placed successfully!',
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Delivery expected by ${_formatDate(deliveryDate)}',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            _buildOrderSummary(orderId, paymentMethod, total),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Ordered Items',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            ...products.map(_buildProductTile).toList(),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.home_rounded),
                    label: Text('Home', style: GoogleFonts.poppins()),
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.local_shipping_outlined),
                    label: Text('Track Order', style: GoogleFonts.poppins()),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTile(Product product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(product.image,
              width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins()),
        subtitle: Text("₹${product.price.toStringAsFixed(2)}",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.check_circle_outline, color: Colors.green),
      ),
    );
  }

  Widget _buildOrderSummary(String orderId, String method, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _summaryRow("Order ID:", orderId),
          const SizedBox(height: 6),
          _summaryRow("Payment Method:", method),
          const SizedBox(height: 6),
          _summaryRow("Total Amount:", "₹${total.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: GoogleFonts.poppins())),
      ],
    );
  }

  static String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
