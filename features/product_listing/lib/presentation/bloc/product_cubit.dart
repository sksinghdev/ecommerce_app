import 'package:common/common.dart';
import 'package:common/core/utils/utils.dart';

import '../../domain/entity/product.dart';
import '../../domain/repository/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit(this._repository) : super(ProductInitial());

  final List<Product> _allProducts = [];
  final List<Product> _displayedProducts = [];

  int _currentPage = 1;
  final int _pageSize = 10;

  bool _isFetchingMore = false;

  Future<void> fetchInitialProducts() async {
    emit(ProductLoading());
    _currentPage = 1;
    _displayedProducts.clear();

    final result = await _repository.getProducts();

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) {
        print('santi size of products ${products.length}');
        _allProducts
          ..clear()
          ..addAll(products);

        print('santi initital _allProducts ${_allProducts.length}');   

        final initialPage = _getNextPage();
        print('santi initital page ${initialPage.length}');
        _displayedProducts.addAll(initialPage);

        emit(ProductLoaded(
          products: List.from(_displayedProducts),
          hasMore: _displayedProducts.length < _allProducts.length,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> fetchMoreProducts() async {
  if (_isFetchingMore || !_hasMore()) return;

  _isFetchingMore = true;

  final currentState = state;
  if (currentState is ProductLoaded) {
    emit(currentState.copyWith(isLoadingMore: true));
  }

await Future.delayed(const Duration(seconds: 2));

  final nextPage = _getNextPage();
  _displayedProducts.addAll(nextPage);

  emit(ProductLoaded(
    products: List.from(_displayedProducts),
    hasMore: _hasMore(),
    isLoadingMore: false,
  ));

  _isFetchingMore = false;
}


  List<Product> _getNextPage() {
    final startIndex = (_currentPage - 1) * _pageSize;

    if (startIndex >= _allProducts.length) return [];

    final endIndex = (_currentPage * _pageSize).clamp(0, _allProducts.length);

    _currentPage++;

    return _allProducts.sublist(startIndex, endIndex);
  }

  bool _hasMore() => _displayedProducts.length < _allProducts.length;

  void navClick(int pos , List<Product> product){
    emitSingleTop(ProductClick(pos: pos, products: product));
  }
}
