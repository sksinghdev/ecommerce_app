import 'package:bloc_test/bloc_test.dart';
import 'package:cart_detail/domain/repository/order_repository.dart';
import 'package:cart_detail/presentation/bloc/order_cubit.dart';
import 'package:cart_detail/presentation/bloc/order_state.dart';
import 'package:common/common.dart';
import 'package:common/data/models/odered_product.dart';
import 'package:common/data/models/order_details_model.dart';
import 'package:common/domain/repository/order_repository_local.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_listing/domain/entity/product.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

class MockOrderRepositoryLocal extends Mock implements OrderRepositoryLocal {}

class FakeProduct extends Fake implements Product {}

class FakeOrderDetailsModel extends Fake implements OrderDetailsModel {}

void main() {
  late OrderCubit cubit;
  late MockOrderRepository mockRemoteRepo;
  late MockOrderRepositoryLocal mockLocalRepo;

  final testProduct = Product(
    id: 1,
    title: 'Test Product',
    price: 10.0,
    description: 'Test description',
    category: 'Test category',
    image: 'test.png',
  );

  final testProducts = [testProduct];
  const testUserId = 101;

  setUpAll(() {
    registerFallbackValue(
      OrderDetailsModel(userId: 0, date: '', products: []),
    );
  });

  setUp(() {
    mockRemoteRepo = MockOrderRepository();
    mockLocalRepo = MockOrderRepositoryLocal();
    cubit = OrderCubit(mockRemoteRepo, mockLocalRepo);
  });

  tearDown(() => cubit.close());

  group('OrderCubit', () {
    test('initial state is OrderInitial', () {
      expect(cubit.state, OrderInitial());
    });

    blocTest<OrderCubit, OrderState>(
      'emits [OrderPlacing, OrderPlaced] on successful order placement',
      build: () {
        when(() => mockRemoteRepo.placedOrders(
              products: any(named: 'products'),
              userId: any(named: 'userId'),
            )).thenAnswer((_) async => right(testProducts));

        when(() => mockLocalRepo.saveOrder(any()))
            .thenAnswer((_) async => Future.value());

        return cubit;
      },
      act: (cubit) => cubit.completeOrder(testProducts, testUserId),
      expect: () => [
        OrderPlacing(),
        OrderPlaced(),
      ],
      verify: (_) {
        verify(() => mockRemoteRepo.placedOrders(
              products: testProducts,
              userId: testUserId,
            )).called(1);
        verify(() => mockLocalRepo.saveOrder(any())).called(1);
      },
    );

    blocTest<OrderCubit, OrderState>(
      'emits [OrderPlacing, OrderFailed] when remote repo fails',
      build: () {
        when(() => mockRemoteRepo.placedOrders(
              products: any(named: 'products'),
              userId: any(named: 'userId'),
            )).thenAnswer(
          (_) async => left(ServerFailure('Order failed')),
        );

        // Even though saveOrder shouldn't be called, mock it just in case
        when(() => mockLocalRepo.saveOrder(any()))
            .thenAnswer((_) async => Future.value());

        return cubit;
      },
      act: (cubit) => cubit.completeOrder(testProducts, testUserId),
      expect: () => [
        OrderPlacing(),
        isA<OrderFailed>()
            .having((e) => e.error, 'error', contains('Order failed')),
      ],
      verify: (_) {
        verify(() => mockRemoteRepo.placedOrders(
              products: testProducts,
              userId: testUserId,
            )).called(1);
        verifyNever(() => mockLocalRepo.saveOrder(any()));
      },
    );
  });
}
