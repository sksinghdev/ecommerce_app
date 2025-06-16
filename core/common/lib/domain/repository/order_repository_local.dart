// domain/repository/order_repository_local.dart

import '../../data/models/order_details_model.dart';

abstract class OrderRepositoryLocal {
  Future<void> saveOrder(OrderDetailsModel order);
  List<OrderDetailsModel> getOrders();
  Future<void> clearOrders();
  Future<void> deleteAllOrders();  
}
