

import 'package:common/common.dart';
import 'package:product_listing/domain/entity/product.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Product> cartItems;

  const CartLoaded(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
