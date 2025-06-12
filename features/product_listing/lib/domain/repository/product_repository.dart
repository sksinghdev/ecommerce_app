 import 'package:common/common.dart';

import '../entity/product.dart';
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}
