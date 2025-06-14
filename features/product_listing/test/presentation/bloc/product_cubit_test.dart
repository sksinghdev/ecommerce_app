import 'package:bloc_test/bloc_test.dart';
import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:product_listing/domain/entity/product.dart';
import 'package:product_listing/domain/repository/product_repository.dart';
import 'package:product_listing/presentation/bloc/product_cubit.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductCubit productCubit;
  late MockProductRepository mockRepository;

  final mockProducts = List.generate(
    25,
    (index) => Product(
      id: index,
      title: 'Product $index',
      price: 10.0,
      description: 'desc',
      category: 'cat',
      image: 'img',
    ),
  );

  setUpAll(() {
    registerFallbackValue(ServerFailure('fallback'));
  });

  setUp(() {
    mockRepository = MockProductRepository();
    productCubit = ProductCubit(mockRepository);
  });

  tearDown(() => productCubit.close());

  group('ProductCubit', () {
    blocTest<ProductCubit, ProductState>(
      'emits [Loading, Loaded] on successful fetchInitialProducts',
      build: () {
        when(() => mockRepository.getProducts())
            .thenAnswer((_) async => Right(mockProducts));
        return productCubit;
      },
      act: (cubit) => cubit.fetchInitialProducts(),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        ProductLoading(),
        isA<ProductLoaded>()
            .having((s) => s.products.length, 'products.length', 10)
            .having((s) => s.hasMore, 'hasMore', true)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ],
      verify: (_) {
        verify(() => mockRepository.getProducts()).called(1);
      },
    );

    blocTest<ProductCubit, ProductState>(
      'emits [Loading, Error] on fetch failure',
      build: () {
        when(() => mockRepository.getProducts())
            .thenAnswer((_) async => Left(ServerFailure('error')));
        return productCubit;
      },
      act: (cubit) => cubit.fetchInitialProducts(),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        ProductLoading(),
        ProductError('error'),
      ],
    );

   blocTest<ProductCubit, ProductState>(
  'emits [Loading, Loaded, LoadingMore, Loaded] when fetchMoreProducts is called',
  build: () {
    when(() => mockRepository.getProducts())
        .thenAnswer((_) async => Right(mockProducts));
    return productCubit;
  },
  act: (cubit) async {
    await cubit.fetchInitialProducts(); // load first 10
    await cubit.fetchMoreProducts(); // load next 10
  },
  wait: const Duration(seconds: 3),
  expect: () => [
    ProductLoading(),
    isA<ProductLoaded>().having((s) => s.products.length, 'products.length', 10)
                         .having((s) => s.isLoadingMore, 'isLoadingMore', false),
    isA<ProductLoaded>().having((s) => s.products.length, 'products.length', 10)
                         .having((s) => s.isLoadingMore, 'isLoadingMore', true),
    isA<ProductLoaded>().having((s) => s.products.length, 'products.length', 20)
                         .having((s) => s.isLoadingMore, 'isLoadingMore', false),
  ],
);


   blocTest<ProductCubit, ProductState>(
  'emits ProductClick and then ProductInitial on navClick',
  build: () => productCubit,
  act: (cubit) => cubit.navClick(2, mockProducts),
  expect: () => [
    ProductClick(pos: 2, products: mockProducts),
    ProductInitial(),
  ],
);

  });
}
