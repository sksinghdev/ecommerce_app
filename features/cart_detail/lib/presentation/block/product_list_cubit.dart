  import 'package:cart_detail/presentation/block/order_cubit.dart';
import 'package:common/common.dart';
import 'package:product_listing/domain/entity/product.dart';

import '../../cart_view.dart';
import '../../data/payment_repository.dart';
 
part 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  

    final PaymentRepository repository;
    final OrderCubit orderCubit; 
  ProductListCubit(this.repository, this.orderCubit) : super(ProductListInitial());

  void loadProducts(List<Product> products) async {
    emit(ProductListLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
      if (products.isEmpty) {
        throw Exception("Product list is empty.");
      }
      final subtotal = products.fold(0.0, (sum, item) => sum + item.price);
      emit(ProductListLoaded(products: products, subtotal: subtotal));
    } catch (e) {
      emit(ProductListError(message: e.toString()));
    }
  }
  Future<void> makePayment(double amount, List<Product> products, int userId) async {
    try {
     // emit(ProductPaymentLoading());
      final intent = await repository.createPaymentIntent(amount, 'usd');
      // "pi_3RZdlIIdA1F8gfjv2ApXnkfu_secret_e661ETRm5EfWAspDRX0BMVy0H"
      print('santi client_sectrect ${intent.clientSecret}');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intent.clientSecret,
          merchantDisplayName: 'FakeStore',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      
      await orderCubit.completeOrder(products, userId);
      emit(ProductPaymentSuccess());
    } catch (e) {
      emit(ProductPaymentError(error: e.toString()));
    }
  }

}
