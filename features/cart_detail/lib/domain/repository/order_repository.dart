 import 'package:common/common.dart';
import 'package:product_listing/domain/entity/product.dart';


abstract class OrderRepository {
  Future<Either<Failure, List<Product>>> placedOrders({
    required int userId,
    required List<Product> products,
  });
}