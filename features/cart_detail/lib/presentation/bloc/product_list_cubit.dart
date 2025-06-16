import 'package:cart_detail/presentation/bloc/order_cubit.dart';
import 'package:common/common.dart';
import 'package:product_listing/domain/entity/product.dart';

import '../../core/service/stripe_service.dart';
import '../../data/payment_repository.dart';

part 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final PaymentRepository repository;
  final OrderCubit orderCubit;
  final StripeService stripeService;
  ProductListCubit(this.repository, this.orderCubit, this.stripeService)
      : super(ProductListInitial());

  void loadProducts(List<Product> products) async {
    emit(ProductListLoading());
    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate loading
      if (products.isEmpty) {
        throw Exception("Product list is empty.");
      }
      final subtotal = products.fold(0.0, (sum, item) => sum + item.price);
      emit(ProductListLoaded(products: products, subtotal: subtotal));
    } catch (e) {
      emit(ProductListError(message: e.toString()));
    }
  }

  Future<void> makePayment(
      double amount, List<Product> products, int userId) async {
    try {
      final intent = await repository.createPaymentIntent(amount, 'usd');

      await stripeService.initPaymentSheet(intent.clientSecret);
      await stripeService.presentPaymentSheet();

      await orderCubit.completeOrder(products, userId);
      emit(ProductPaymentSuccess());
    } catch (e) {
      emit(ProductPaymentError(error: e.toString()));
    }
  }
}
