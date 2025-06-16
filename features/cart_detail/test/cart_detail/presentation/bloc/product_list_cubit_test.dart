



import 'package:bloc_test/bloc_test.dart';
import 'package:cart_detail/core/service/stripe_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cart_detail/data/payment_repository.dart';
import 'package:cart_detail/domain/payment_intent.dart';
import 'package:cart_detail/presentation/bloc/product_list_cubit.dart';
import 'package:cart_detail/presentation/bloc/order_cubit.dart';
import 'package:product_listing/domain/entity/product.dart';
 
class MockPaymentRepository extends Mock implements PaymentRepository {}

class MockOrderCubit extends Mock implements OrderCubit {}
class MockStripeService extends Mock implements StripeService {}
 
void main() {
  late ProductListCubit cubit;
  late MockPaymentRepository mockRepo;
  late MockOrderCubit mockOrderCubit;
  late MockStripeService mockStripeService;

  setUpAll(() {
   // registerFallbackValue<List<Product>>([]);
  });

  setUp(() {
    mockRepo = MockPaymentRepository();
    mockOrderCubit = MockOrderCubit();
    mockStripeService = MockStripeService();
    cubit = ProductListCubit(mockRepo, mockOrderCubit,mockStripeService);
  });

  final sampleProducts = [
    Product(
      id: 1,
      title: 'T-shirt',
      price: 25.0,
      description: 'Cotton T-shirt',
      category: 'Clothing',
      image: 'image_url',
    ),
    Product(
      id: 2,
      title: 'Shoes',
      price: 75.0,
      description: 'Running Shoes',
      category: 'Footwear',
      image: 'image_url',
    ),
  ];

  group('loadProducts', () {
    blocTest<ProductListCubit, ProductListState>(
      'emits [Loading, Loaded] when products are non-empty',
      build: () => cubit,
      act: (cubit) => cubit.loadProducts(sampleProducts),
      expect: () => [
        ProductListLoading(),
        isA<ProductListLoaded>()
            .having((s) => s.products.length, 'products length', 2)
            .having((s) => s.subtotal, 'subtotal', 100.0),
      ],
    );

    blocTest<ProductListCubit, ProductListState>(
      'emits [Loading, Error] when products are empty',
      build: () => cubit,
      act: (cubit) => cubit.loadProducts([]),
      expect: () => [
        ProductListLoading(),
        isA<ProductListError>()
            .having((s) => s.message, 'message', contains('Product list is empty')),
      ],
    );
  });

  group('makePayment', () {
    final intent = PaymentIntent(
      clientSecret: 'test_client_secret',
    );

    // setUp(() {
    //   // Normally Stripe is static, so you can't mock it directly.
    //   // Either wrap it or assume it works in unit tests.
    // });

   blocTest<ProductListCubit, ProductListState>(
  'emits ProductPaymentSuccess when payment and order complete successfully',
  build: () {
    when(() => mockRepo.createPaymentIntent(100.0, 'usd'))
        .thenAnswer((_) async => intent);
    when(() => mockStripeService.initPaymentSheet(any()))
        .thenAnswer((_) async => {});
    when(() => mockStripeService.presentPaymentSheet())
        .thenAnswer((_) async => {});
    when(() => mockOrderCubit.completeOrder(any(), any()))
        .thenAnswer((_) async => {});

    return ProductListCubit(mockRepo, mockOrderCubit, mockStripeService);
  },
  act: (cubit) async {
    await cubit.makePayment(100.0, sampleProducts, 1);
  },
  expect: () => [
    ProductPaymentSuccess(),
  ],
);


    blocTest<ProductListCubit, ProductListState>(
      'emits ProductPaymentError when payment fails',
      build: () {
        when(() => mockRepo.createPaymentIntent(100.0, 'usd'))
            .thenThrow(Exception('Payment failed'));
        return cubit;
      },
      act: (cubit) => cubit.makePayment(100.0, sampleProducts, 1),
      expect: () => [
        isA<ProductPaymentError>().having((e) => e.error, 'error', contains('Payment failed')),
      ],
    );
  });
}
