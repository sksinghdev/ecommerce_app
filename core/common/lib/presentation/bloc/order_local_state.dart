// lib/cart_detail/presentation/bloc/order_local_state.dart

part of 'order_local_cubit.dart';

abstract class OrderLocalState extends Equatable {
  const OrderLocalState();

  @override
  List<Object?> get props => [];
}

class OrderLocalInitial extends OrderLocalState {}

class OrderLocalLoading extends OrderLocalState {}

class OrderLocalLoaded extends OrderLocalState {
  final List<OrderDetailsModel> orders;

  const OrderLocalLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderLocalCleared extends OrderLocalState {}

class OrderLocalError extends OrderLocalState {
  final String message;

  const OrderLocalError(this.message);

  @override
  List<Object?> get props => [message];
}
