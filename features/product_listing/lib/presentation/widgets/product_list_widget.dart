import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:common/common.dart';
import 'package:product_cart/core/injection/cart_router.gr.dart';
import 'package:shimmer/shimmer.dart';
import 'package:product_listing/presentation/bloc/product_cubit.dart';
import 'package:authentication/core/injections/auth_router.gr.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductClick) {
            context.pushRoute(ProductCarts(
              pos: state.pos,
              products: state.products,
            ));
          }
        },
        builder: (context, state) {
          if (state is ProductInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ProductCubit>().fetchInitialProducts();
            });
            return _buildShimmerList();
          }

          if (state is ProductLoading) {
            return _buildShimmerList();
          }

          if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          if (state is ProductLoaded) {
            final products = state.products;
            final hasMore = state.hasMore;
            final isLoadingMore = state.isLoadingMore;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductCubit>().fetchInitialProducts();
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.metrics.pixels >=
                          scrollNotification.metrics.maxScrollExtent - 200 &&
                      hasMore &&
                      !isLoadingMore) {
                    context.read<ProductCubit>().fetchMoreProducts();
                  }
                  return false;
                },
                child: SafeArea(
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
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
                          GestureDetector(
                            child: Icon(Icons.manage_history),
                            onTap: () {},
                          ),
                          SizedBox(width: 20,),
                          GestureDetector(
                            child: Icon(Icons.logout),
                            onTap: () {
                              showLogoutConfirmationDialog(context);
                            },
                          ), 
                          SizedBox(width: 20,)
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index < products.length) {
                              final product = products[index];
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<ProductCubit>()
                                      .navClick(index, products);
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: 4,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(12),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(product.image,
                                          width: 60, height: 60),
                                    ),
                                    title: Text(product.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    subtitle: Text(product.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    trailing: Text("\$${product.price}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              );
                            }

                            if (isLoadingMore) {
                              return _buildShimmerTile();
                            }

                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'No more products available.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            );
                          },
                          childCount: products.length + 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
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
    barrierDismissible: false, // must choose
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
            // ✅ Perform logout directly here
            await FirebaseAuth.instance.signOut();

            // ✅ Then close the dialog
            Navigator.of(context).pop();

            // ✅ Then navigate to login (after dialog closes)
            context.replaceRoute(const LoginRoute()); // or context.router.replace(...)
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Logout'),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

}
