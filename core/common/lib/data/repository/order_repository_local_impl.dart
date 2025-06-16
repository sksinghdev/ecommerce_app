// data/repositories/order_repository_local_impl.dart

import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/repository/order_repository_local.dart';
import '../models/order_details_model.dart';

class OrderRepositoryLocalImpl implements OrderRepositoryLocal {
  final Box<OrderDetailsModel> box;

  OrderRepositoryLocalImpl(this.box);

  @override
  Future<void> saveOrder(OrderDetailsModel order) async {
    await box.add(order);
  }

  @override
  List<OrderDetailsModel> getOrders() => box.values.toList();

  @override
  Future<void> clearOrders() async => await box.clear();

  @override
  Future<void> deleteAllOrders() async {
    await box.clear();
  }
}
