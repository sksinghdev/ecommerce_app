import 'package:bloc_test/bloc_test.dart';
import 'package:common/data/models/odered_product.dart';
import 'package:common/data/models/order_details_model.dart';
import 'package:common/domain/repository/order_repository_local.dart';
import 'package:common/presentation/bloc/order_local_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderRepositoryLocal extends Mock implements OrderRepositoryLocal {}

void main() {
  late MockOrderRepositoryLocal mockRepository;
  late OrderLocalCubit cubit;

  final sampleProduct = OderedProduct(
    id: 1,
    title: 'Test Product',
    price: 99.99,
    description: 'A great product',
    image: 'https://example.com/image.jpg',
  );

  final sampleOrder = OrderDetailsModel(
    userId: 1,
    date: '2025-06-16T00:00:00Z',
    products: [sampleProduct],
  );

  setUp(() {
    mockRepository = MockOrderRepositoryLocal();
    cubit = OrderLocalCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('OrderLocalCubit Tests (GIVEN-WHEN-THEN)', () {
    blocTest<OrderLocalCubit, OrderLocalState>(
      'GIVEN orders exist WHEN loadOrders is called THEN emits [Loading, Loaded]',
      build: () {
        when(() => mockRepository.getOrders()).thenReturn([sampleOrder]);
        return cubit;
      },
      act: (cubit) => cubit.loadOrders(),
      expect: () => [
        OrderLocalLoading(),
        OrderLocalLoaded([sampleOrder]),
      ],
      verify: (_) {
        verify(() => mockRepository.getOrders()).called(1);
      },
    );

    blocTest<OrderLocalCubit, OrderLocalState>(
      'GIVEN repository throws error WHEN loadOrders is called THEN emits [Loading, Error]',
      build: () {
        when(() => mockRepository.getOrders())
            .thenThrow(Exception('DB failed'));
        return cubit;
      },
      act: (cubit) => cubit.loadOrders(),
      expect: () => [
        OrderLocalLoading(),
        isA<OrderLocalError>().having(
            (e) => e.message, 'message', contains('Failed to load orders')),
      ],
      verify: (_) {
        verify(() => mockRepository.getOrders()).called(1);
      },
    );

    blocTest<OrderLocalCubit, OrderLocalState>(
      'GIVEN order is saved successfully WHEN saveOrder is called THEN emits [Loading, Loaded]',
      build: () {
        when(() => mockRepository.saveOrder(sampleOrder))
            .thenAnswer((_) async {});
        when(() => mockRepository.getOrders()).thenReturn([sampleOrder]);
        return cubit;
      },
      act: (cubit) => cubit.saveOrder(sampleOrder),
      expect: () => [
        OrderLocalLoading(),
        OrderLocalLoaded([sampleOrder]),
      ],
      verify: (_) {
        verify(() => mockRepository.saveOrder(sampleOrder)).called(1);
        verify(() => mockRepository.getOrders()).called(1);
      },
    );

    blocTest<OrderLocalCubit, OrderLocalState>(
      'GIVEN repository throws WHEN saveOrder is called THEN emits [Error]',
      build: () {
        when(() => mockRepository.saveOrder(sampleOrder))
            .thenThrow(Exception('save failed'));
        return cubit;
      },
      act: (cubit) => cubit.saveOrder(sampleOrder),
      expect: () => [
        isA<OrderLocalError>().having(
            (e) => e.message, 'message', contains('Failed to save order')),
      ],
    );

    blocTest<OrderLocalCubit, OrderLocalState>(
      'GIVEN delete is successful WHEN deleteAllOrders is called THEN emits [Cleared]',
      build: () {
        when(() => mockRepository.deleteAllOrders()).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.deleteAllOrders(),
      expect: () => [
        OrderLocalCleared(),
      ],
      verify: (_) {
        verify(() => mockRepository.deleteAllOrders()).called(1);
      },
    );

    blocTest<OrderLocalCubit, OrderLocalState>(
      'GIVEN repository throws WHEN deleteAllOrders is called THEN emits [Error]',
      build: () {
        when(() => mockRepository.deleteAllOrders())
            .thenThrow(Exception('delete failed'));
        return cubit;
      },
      act: (cubit) => cubit.deleteAllOrders(),
      expect: () => [
        isA<OrderLocalError>().having(
            (e) => e.message, 'message', contains('Failed to delete orders')),
      ],
    );
  });
}
