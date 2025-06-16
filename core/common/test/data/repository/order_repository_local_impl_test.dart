import 'package:common/data/models/odered_product.dart';
import 'package:common/data/models/order_details_model.dart';
import 'package:common/data/repository/order_repository_local_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';

class MockOrderBox extends Mock implements Box<OrderDetailsModel> {}

void main() {
  late MockOrderBox mockBox;
  late OrderRepositoryLocalImpl repository;

  final sampleProduct = OderedProduct(
    id: 1,
    title: 'Test Product',
    price: 99.99,
    description: 'A great test product',
    image: 'https://example.com/image.jpg',
  );

  final sampleOrder = OrderDetailsModel(
    userId: 42,
    date: '2025-06-16T10:00:00Z',
    products: [sampleProduct],
  );

  setUp(() {
    mockBox = MockOrderBox();
    repository = OrderRepositoryLocalImpl(mockBox);
  });

  setUpAll(() {
    registerFallbackValue(
      OrderDetailsModel(userId: 0, date: '', products: []),
    );
  });

  group('OrderRepositoryLocalImpl Tests (GIVEN-WHEN-THEN)', () {
    test(
        'GIVEN an order, WHEN saveOrder is called, THEN it should add the order to the box',
        () async {
      // GIVEN
      when(() => mockBox.add(sampleOrder)).thenAnswer((_) async => 0);

      // WHEN
      await repository.saveOrder(sampleOrder);

      // THEN
      verify(() => mockBox.add(sampleOrder)).called(1);
    });

    test(
        'GIVEN orders exist in box, WHEN getOrders is called, THEN it should return the list of orders',
        () {
      // GIVEN
      final orders = [sampleOrder];
      when(() => mockBox.values).thenReturn(orders);

      // WHEN
      final result = repository.getOrders();

      // THEN
      expect(result, equals(orders));
      verify(() => mockBox.values).called(1);
    });

    test(
        'GIVEN the box is initialized, WHEN clearOrders is called, THEN it should clear the box',
        () async {
      // GIVEN
      when(() => mockBox.clear()).thenAnswer((_) async => 0);

      // WHEN
      await repository.clearOrders();

      // THEN
      verify(() => mockBox.clear()).called(1);
    });

    test(
        'GIVEN the box is initialized, WHEN deleteAllOrders is called, THEN it should clear the box',
        () async {
      // GIVEN
      when(() => mockBox.clear()).thenAnswer((_) async => 0);

      // WHEN
      await repository.deleteAllOrders();

      // THEN
      verify(() => mockBox.clear()).called(1);
    });
  });
}
