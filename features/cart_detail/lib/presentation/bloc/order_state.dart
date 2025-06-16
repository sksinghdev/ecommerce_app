import 'package:common/common.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {}

class OrderFailed extends OrderState {
  final String error;

  const OrderFailed({required this.error});

  @override
  List<Object?> get props => [error];
}
