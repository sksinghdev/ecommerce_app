import 'package:common/common.dart';

import '../../domain/entity/product.dart';
import '../../domain/repository/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  static const int _itemsPerPage = 10;
  List<Product> _allProducts = [];
  int _currentPage = 0;

  ProductCubit({required this.repository}) : super(ProductInitial());

  Future<void> fetchInitialProducts() async {
    emit(ProductLoading());
    final result = await repository.getProducts();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) {
        _allProducts = products;
        _currentPage = 1;
        final initialItems = _getPageItems();
        emit(ProductLoaded(initialItems, _hasMore()));
      },
    );
  }

  void fetchMoreProducts() {
    if (!_hasMore()) return;

    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      _currentPage += 1;
      final newItems = _getPageItems();
      final updatedList = [...currentState.products, ...newItems];
      emit(ProductLoaded(updatedList, _hasMore()));
    }
  }

  List<Product> _getPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _allProducts.sublist(
      startIndex,
      endIndex > _allProducts.length ? _allProducts.length : endIndex,
    );
  }

  bool _hasMore() {
    return _currentPage * _itemsPerPage < _allProducts.length;
  }
}
