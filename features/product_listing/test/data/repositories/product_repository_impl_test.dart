import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:common/common.dart'; // For Either, Failure, etc.
import 'package:product_listing/data/repositories/product_repository_impl.dart';

 import 'package:product_listing/domain/entity/product.dart';
import 'package:product_listing/domain/entity/roduct_model.dart';
import 'package:product_listing/domain/repository/product_repository.dart';

// Mock ApiService
class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  late ProductRepositoryImpl repository;

  setUp(() {
    mockApiService = MockApiService();
    repository = ProductRepositoryImpl(apiService: mockApiService);
  });

  group('getProducts', () {
    test('returns list of products on 200 response', () async {
      final mockJson = {
        "id": 1,
        "title": "Product A",
        "price": 10.0,
        "description": "Sample",
        "category": "Test",
        "image": "http://image.png"
      };

      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: [mockJson],
      );

      when(() => mockApiService.getProducts())
          .thenAnswer((_) async => response);

      final result = await repository.getProducts();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isA<List<Product>>());
      expect(result.getOrElse(() => []).first.title, equals("Product A"));
    });

    test('returns ServerFailure on non-200 status code', () async {
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        data: null,
      );

      when(() => mockApiService.getProducts())
          .thenAnswer((_) async => response);

      final result = await repository.getProducts();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockApiService.getProducts())
          .thenThrow(Exception('network error'));

      final result = await repository.getProducts();

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('network error'));
        },
        (_) => fail('Expected failure'),
      );
    });
  });
}
