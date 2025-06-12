
import 'package:flutter/material.dart';
import '../../domain/entity/product.dart';
import '../bloc/product_cubit.dart';

import 'package:common/common.dart' as common;


class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final cubit = context.read<ProductCubit>();
      final state = cubit.state;
      if (state is ProductLoaded && state.hasMore) {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
          cubit.fetchMoreProducts();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProductCard(Product product, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 50),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
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
          title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: Text("\$${product.price}", style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return common.BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductError) {
          return Center(child: Text(state.message));
        }

        if (state is ProductLoaded) {
          return CustomScrollView(
            controller: _scrollController,
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
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < state.products.length) {
                      return _buildProductCard(state.products[index], index);
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                  childCount:
                      state.products.length + (state.hasMore ? 1 : 0),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
