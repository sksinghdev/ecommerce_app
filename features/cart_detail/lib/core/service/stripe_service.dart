// stripe_service.dart
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  final Stripe stripe;

  StripeService({Stripe? stripeInstance})
      : stripe = stripeInstance ?? Stripe.instance;

  Future<void> initPaymentSheet(String clientSecret) async {
    await stripe.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'FakeStore',
      ),
    );
  }

  Future<void> presentPaymentSheet() async {
    await stripe.presentPaymentSheet();
  }
}
