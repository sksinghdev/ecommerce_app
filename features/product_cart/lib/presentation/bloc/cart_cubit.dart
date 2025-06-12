import 'package:common/common.dart';
import 'package:product_listing/domain/entity/product.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<Product> _items = [];

  void addOrRemoveFromCart(Product product) async {
    emit(CartLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      if (_items.contains(product)) {
        _items.remove(product);
      } else {
        _items.add(product);
      }

      emit(CartLoaded(List.from(_items)));
    } catch (_) {
      emit(const CartError('Failed to update cart.'));
    }
  }

  int get cartCount => _items.length;

  bool isInCart(Product product) => _items.contains(product);
}
