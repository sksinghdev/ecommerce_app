part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;

  const ProductLoaded({
    required this.products,
    required this.hasMore,
    required this.isLoadingMore,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [products, hasMore, isLoadingMore];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
