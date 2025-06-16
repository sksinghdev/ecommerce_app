import 'package:cart_detail/domain/payment_intent.dart';
import 'package:common/common.dart';


class PaymentRepository {
  final Dio dio;

  PaymentRepository(this.dio);

  Future<PaymentIntent> createPaymentIntent(double amount, String currency) async {
    final response = await dio.post(
      'http://localhost:3000/create-payment-intent', // Or a mock backend
      data: {
        'amount': (amount * 100).toInt(), // Stripe needs the amount in cents
        'currency': currency,
      },
    );

    return PaymentIntent.fromJson(response.data);
  }
}
