import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:cart_detail/domain/payment_intent.dart';
import 'package:common/common.dart';  
import 'package:cart_detail/data/payment_repository.dart';  

class MockDio extends Mock implements Dio {}

void main() {
  late PaymentRepository paymentRepository;
  late MockDio mockDio;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockDio = MockDio();
    paymentRepository = PaymentRepository(mockDio);
  });

  group('createPaymentIntent', () {
    const amount = 10.0;
    const currency = 'usd';

    final mockResponseData = {
      'clientSecret': 'sk_test_1234567890abcdef',
      'amount': 1000,
      'currency': 'usd',
    };

    test('returns PaymentIntent on successful response', () async {
      // Arrange
      final response = Response(
        statusCode: 200,
        data: mockResponseData,
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => response);

      // Act
      final result = await paymentRepository.createPaymentIntent(amount, currency);

      // Assert
      expect(result, isA<PaymentIntent>());
      expect(result.clientSecret, 'sk_test_1234567890abcdef');
    
    });

    test('throws DioError on failure response', () async {
      // Arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(DioError(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              statusCode: 400,
              data: {'error': 'Invalid request'},
              requestOptions: RequestOptions(path: ''),
            ),
            type: DioErrorType.badResponse,
          ));

      // Act & Assert
      expect(
        () => paymentRepository.createPaymentIntent(amount, currency),
        throwsA(isA<DioError>()),
      );
    });
  });
}
