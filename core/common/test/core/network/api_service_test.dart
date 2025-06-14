import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
 
class MockDio extends Mock implements Dio {}

void main() {
  late ApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = ApiService(mockDio);
  });

  group('ApiService', () {
    test('getProducts should call GET /products', () async {
      final response = Response(
        data: [],
        statusCode: 200,
        requestOptions: RequestOptions(path: 'products'),
      );

      when(() => mockDio.get('products')).thenAnswer((_) async => response);

      final result = await apiService.getProducts();

      expect(result.statusCode, 200);
      verify(() => mockDio.get('products')).called(1);
    });

    test('createUser should call POST /users with data', () async {
      final userData = {'name': 'Santosh'};
      final response = Response(
        data: {'id': 1},
        statusCode: 201,
        requestOptions: RequestOptions(path: 'users'),
      );

      when(() => mockDio.post('users', data: userData))
          .thenAnswer((_) async => response);

      final result = await apiService.createUser(userData);

      expect(result.data['id'], 1);
      verify(() => mockDio.post('users', data: userData)).called(1);
    });

    test('orderPlacedAfterPayment should call POST /carts with data', () async {
      final orderData = {'items': [1, 2]};
      final response = Response(
        data: {'status': 'success'},
        statusCode: 200,
        requestOptions: RequestOptions(path: 'carts'),
      );

      when(() => mockDio.post('carts', data: orderData))
          .thenAnswer((_) async => response);

      final result = await apiService.orderPlacedAfterPayment(orderData);

      expect(result.data['status'], 'success');
      verify(() => mockDio.post('carts', data: orderData)).called(1);
    });

    test('getUserById should call GET /users/:id', () async {
      const userId = 1;
      final response = Response(
        data: {'id': userId, 'name': 'Santosh'},
        statusCode: 200,
        requestOptions: RequestOptions(path: 'users/$userId'),
      );

      when(() => mockDio.get('users/$userId'))
          .thenAnswer((_) async => response);

      final result = await apiService.getUserById(userId);

      expect(result.data['name'], 'Santosh');
      verify(() => mockDio.get('users/$userId')).called(1);
    });
  });
}
