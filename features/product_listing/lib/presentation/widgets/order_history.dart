import 'package:common/data/models/odered_product.dart';
import 'package:common/data/models/order_details_model.dart';
import 'package:common/presentation/bloc/order_local_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:common/common.dart';
import 'package:ecommerce_app/src/application/di/injection_container.dart';

@RoutePage()
class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<OrderLocalCubit>()..loadOrders(),
      child: const OrderHistoryView(),
    );
  }
}

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: BlocBuilder<OrderLocalCubit, OrderLocalState>(
        builder: (context, state) {
          if (state is OrderLocalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLocalLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text("No orders found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return _buildOrderSection(order, index + 1); // Order #1, #2...
              },
            );
          } else if (state is OrderLocalError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildOrderSection(OrderDetailsModel order, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order #$index - ${order.date}",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...order.products.map((product) => _buildProductTile(product)).toList(),
        const Divider(height: 32, thickness: 1),
      ],
    );
  }

  Widget _buildProductTile(OderedProduct product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          ),
        ),
        title: Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(),
        ),
        subtitle: Text(
          "₹${product.price.toStringAsFixed(2)}",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.check_circle_outline, color: Colors.green),
      ),
    );
  }
}
