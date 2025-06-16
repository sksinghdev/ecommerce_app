import 'package:cart_detail/core/service/stripe_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mocktail/mocktail.dart';

// Mock class
class MockStripe extends Mock implements Stripe {}

void main() {
  late StripeService stripeService;
  late MockStripe mockStripe;

  setUpAll(() {
    registerFallbackValue(
      SetupPaymentSheetParameters(
        paymentIntentClientSecret: '',
        merchantDisplayName: '',
      ),
    );
  });

  setUp(() {
    mockStripe = MockStripe();
    stripeService = StripeService(stripeInstance: mockStripe);
  });

  group('StripeService', () {
    const clientSecret = 'test_client_secret';

    test('calls initPaymentSheet with correct parameters', () async {
      when(() => mockStripe.initPaymentSheet(
            paymentSheetParameters: any(named: 'paymentSheetParameters'),
          )).thenAnswer((_) async {});

      await stripeService.initPaymentSheet(clientSecret);

      final captured = verify(() => mockStripe.initPaymentSheet(
            paymentSheetParameters: captureAny(named: 'paymentSheetParameters'),
          )).captured.single as SetupPaymentSheetParameters;

      expect(captured.paymentIntentClientSecret, equals(clientSecret));
      expect(captured.merchantDisplayName, equals('FakeStore'));
    });

    test('calls presentPaymentSheet', () async {
      when(() => mockStripe.presentPaymentSheet()).thenAnswer((_) async {});

      await stripeService.presentPaymentSheet();

      verify(() => mockStripe.presentPaymentSheet()).called(1);
    });
  });
}
