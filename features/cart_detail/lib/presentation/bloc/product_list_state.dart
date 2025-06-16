part of 'product_list_cubit.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductPaymentLoading extends ProductListState {}

class ProductPaymentSuccess extends ProductListState {}

class ProductPaymentError extends ProductListState {
  final String error;
  const ProductPaymentError({required this.error});
}

class ProductListLoaded extends ProductListState {
  final List<Product> products;
  final double subtotal;

  const ProductListLoaded({required this.products, required this.subtotal});

  @override
  List<Object?> get props => [products, subtotal];
}

class ProductListError extends ProductListState {
  final String message;

  const ProductListError({required this.message});

  @override
  List<Object?> get props => [message];
}
