import 'package:cart_detail/data/repositories/order_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:common/common.dart';
 import 'package:product_listing/domain/entity/product.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late OrderRepositoryImpl repository;
  late MockApiService mockApiService;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockApiService = MockApiService();
    repository = OrderRepositoryImpl(mockApiService);
  });

  final testProducts = [
    Product(
      id: 1,
      title: 'Test Product',
      price: 9.99,
      description: 'Test Desc',
      category: 'Test Cat',
      image: 'test.jpg',
    ),
  ];

  final mockResponseData = {
    'products': [
      {
        'id': 1,
        'title': 'Test Product',
        'price': 9.99,
        'description': 'Test Desc',
        'category': 'Test Cat',
        'image': 'test.jpg',
      },
    ]
  };

  group('OrderRepositoryImpl - placedOrders (Dio)', () {
    test('returns Right(List<Product>) when Dio response is 200', () async {
      // Arrange
      final dioResponse = Response(
        statusCode: 200,
        data: mockResponseData,
        requestOptions: RequestOptions(path: '/orders'),
      );

      when(() => mockApiService.orderPlacedAfterPayment(any()))
          .thenAnswer((_) async => dioResponse);

      // Act
      final result = await repository.placedOrders(userId: 1, products: testProducts);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right but got Left'),
        (products) {
          expect(products, isA<List<Product>>());
          expect(products.first.id, 1);
        },
      );
    });

    test('returns Left(ServerFailure) when Dio response statusCode is not 200/201', () async {
      final dioResponse = Response(
        statusCode: 500,
        data: {},
        requestOptions: RequestOptions(path: '/orders'),
      );

      when(() => mockApiService.orderPlacedAfterPayment(any()))
          .thenAnswer((_) async => dioResponse);

      final result = await repository.placedOrders(userId: 1, products: testProducts);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('throws Exception when Dio throws an error', () async {
      when(() => mockApiService.orderPlacedAfterPayment(any()))
          .thenThrow(DioError(
            requestOptions: RequestOptions(path: '/orders'),
            type: DioErrorType.unknown,
            error: 'Network Error',
          ));

      expect(
        () => repository.placedOrders(userId: 1, products: testProducts),
        throwsA(isA<Exception>()),
      );
    });
  });
}
