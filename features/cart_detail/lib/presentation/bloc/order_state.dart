

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {}

class OrderFailed extends OrderState {
  final String error;

  OrderFailed({required this.error});
}
