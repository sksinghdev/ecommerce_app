import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:common/common.dart';
import 'package:product_cart/core/injection/cart_router.gr.dart';
import 'package:product_listing/core/injection/product_router.gr.dart';
import 'package:product_listing/domain/entity/product.dart';
import 'package:shimmer/shimmer.dart';
import 'package:product_listing/presentation/bloc/product_cubit.dart';
import 'package:authentication/core/injections/auth_router.gr.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: _onStateChange,
        builder: (context, state) => _buildStateUI(context, state),
      ),
    );
  }

  void _onStateChange(BuildContext context, ProductState state) {
    if (state is ProductClick) {
      context.pushRoute(ProductCarts(pos: state.pos, products: state.products));
    }
  }

  Widget _buildStateUI(BuildContext context, ProductState state) {
    if (state is ProductInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductCubit>().fetchInitialProducts();
      });
      return _buildShimmerList();
    }

    if (state is ProductLoading) return _buildShimmerList();

    if (state is ProductError) return Center(child: Text(state.message));

    if (state is ProductLoaded) {
      return _buildProductList(context, state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildProductList(BuildContext context, ProductLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductCubit>().fetchInitialProducts();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) =>
            _handleScrollNotification(context, scrollNotification, state),
        child: SafeArea(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              _buildProductSliverList(context, state),
            ],
          ),
        ),
      ),
    );
  }

  bool _handleScrollNotification(
    BuildContext context,
    ScrollNotification scrollNotification,
    ProductLoaded state,
  ) {
    if (scrollNotification is ScrollUpdateNotification &&
        scrollNotification.metrics.pixels >=
            scrollNotification.metrics.maxScrollExtent - 200 &&
        state.hasMore &&
        !state.isLoadingMore) {
      context.read<ProductCubit>().fetchMoreProducts();
    }
    return false;
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text('Products'),
        background: Image.network(
          'https://picsum.photos/800/300?blur',
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.manage_history),
          onPressed: () => context.pushRoute(OrderHistory()),
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => showLogoutConfirmationDialog(context),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildProductSliverList(BuildContext context, ProductLoaded state) {
    final products = state.products;
    final isLoadingMore = state.isLoadingMore;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index < products.length) {
            return _buildProductTile(context, products[index], index, products);
          }

          if (isLoadingMore) return _buildShimmerTile();

          return _buildNoMoreProductsMessage();
        },
        childCount: products.length + 1,
      ),
    );
  }

  Widget _buildProductTile(
    BuildContext context,
    Product product,
    int index,
    List<Product> products,
  ) {
    return GestureDetector(
      onTap: () => context.read<ProductCubit>().navClick(index, products),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(product.image, width: 60, height: 60),
          ),
          title:
              Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(product.description,
              maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: Text("\$${product.price}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildNoMoreProductsMessage() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'No more products available.',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => _buildShimmerTile(),
    );
  }

  Widget _buildShimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            color: Colors.white,
          ),
          title: Container(
            height: 12,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),
          subtitle: Container(
            height: 12,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),
        ),
      ),
    );
  }

  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
              context.replaceRoute(const LoginRoute());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }
}
