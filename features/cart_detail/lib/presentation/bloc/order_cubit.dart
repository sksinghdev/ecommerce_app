import 'package:cart_detail/presentation/bloc/order_state.dart';
import 'package:common/common.dart';
import 'package:common/data/models/odered_product.dart';
import 'package:common/data/models/order_details_model.dart';
import 'package:common/domain/repository/order_repository_local.dart';
import 'package:product_listing/domain/entity/product.dart';

import '../../domain/repository/order_repository.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;
  final OrderRepositoryLocal orderRepositoryLocal;

  OrderCubit(this.repository, this.orderRepositoryLocal)
      : super(OrderInitial());

  Future<void> completeOrder(List<Product> products, int userId) async {
    emit(OrderPlacing());
    try {
      final result =
          await repository.placedOrders(products: products, userId: userId);
      result.fold(
        (failure) => emit(OrderFailed(error: failure.message)),
        (products) async {
          final data = _getOrderDetailsModel(products, userId);
          await orderRepositoryLocal.saveOrder(data);
          emit(OrderPlaced());
        },
      );
    } catch (e) {
      emit(OrderFailed(error: e.toString()));
    }
  }

  OrderDetailsModel _getOrderDetailsModel(List<Product> products, int userId) {
    final orderedProducts = products.map((product) {
      return OderedProduct(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        image: product.image,
      );
    }).toList();

    final now = DateTime.now().toIso8601String();

    return OrderDetailsModel(
      userId: userId,
      date: now,
      products: orderedProducts,
    );
  }
}
