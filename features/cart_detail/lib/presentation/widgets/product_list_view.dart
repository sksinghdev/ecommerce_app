import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:common/common.dart';
import '../../core/injection/cart_details_router.gr.dart';
import '../block/product_list_cubit.dart';
import 'package:product_listing/domain/entity/product.dart';

class ProductListView extends StatelessWidget {
  final List<Product> products;

  const ProductListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProductListCubit, ProductListState>(
         listener: (context, state) {
          if(state is ProductPaymentSuccess){
            context.replaceRoute(OrderSuccessRoute(products: products,paymentMethod: '**** **** **** **** 4242',orderId: '233456890',deliveryDate: DateTime.now()));
          }
         },
        builder: (context, state) {
          if (state is ProductListInitial || state is ProductListLoading) {
            context.read<ProductListCubit>().loadProducts(products);
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductListError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is ProductListLoaded) {
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  SliverToBoxAdapter(child: _buildProductList(state.products)),
                  SliverToBoxAdapter(child: _buildSubtotalAndPayButton(context, state)),
                ],
              ),
            );
          }

          return const Center(child: Text("Unknown state"));
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 120,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text("Product List"),
        background: ColoredBox(color: Colors.blue),
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(product.title),
          subtitle: Text(product.category),
          trailing: Text("\$${product.price.toStringAsFixed(2)}"),
        );
      },
    );
  }

  Widget _buildSubtotalAndPayButton(BuildContext context, ProductListLoaded state) {
    return Column(
      children: [
        _buildSubtotalRow(state.subtotal),
        const SizedBox(height: 12),
        _buildPayButton(context, state),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSubtotalRow(double subtotal) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Subtotal:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("\$${subtotal.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildPayButton(BuildContext context, ProductListLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.green,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Proceeding to payment...')),
            );

            /// TODO: Replace with actual user ID from auth state
            const int userId = 23;
            context.read<ProductListCubit>().makePayment(
                  state.subtotal,
                  state.products,
                  userId,
                );
          },
          icon: Text('💸', style: GoogleFonts.roboto(fontSize: 24)),
          label: Text(
            'Make Payment',
            style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
