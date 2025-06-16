import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/order_details_model.dart';
import '../../domain/repository/order_repository_local.dart';

part 'order_local_state.dart';

class OrderLocalCubit extends Cubit<OrderLocalState> {
  final OrderRepositoryLocal repository;

  OrderLocalCubit(this.repository) : super(OrderLocalInitial());

  Future<void> loadOrders() async {
    emit(OrderLocalLoading());
    try {
      final orders = repository.getOrders();
      emit(OrderLocalLoaded(orders));
    } catch (e) {
      emit(OrderLocalError('Failed to load orders: $e'));
    }
  }

  Future<void> saveOrder(OrderDetailsModel order) async {
    try {
      await repository.saveOrder(order);
      loadOrders();
    } catch (e) {
      emit(OrderLocalError('Failed to save order: $e'));
    }
  }

  Future<void> deleteAllOrders() async {
    try {
      await repository.deleteAllOrders();
      emit(OrderLocalCleared());
    } catch (e) {
      emit(OrderLocalError('Failed to delete orders: $e'));
    }
  }
}
