
import 'package:cart_detail/presentation/block/order_state.dart';
import 'package:common/common.dart';
import 'package:product_listing/domain/entity/product.dart';

import '../../data/order_repository.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;

  OrderCubit(this.repository) : super(OrderInitial());

  Future<void> completeOrder(List<Product> products, int userId) async {
    emit(OrderPlacing());
    try {
      await repository.placeOrder(products, userId);
      emit(OrderPlaced());
    } catch (e) {
      emit(OrderFailed(error: e.toString()));
    }
  }
}
