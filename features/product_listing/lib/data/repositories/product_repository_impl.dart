

import 'package:common/common.dart';

import '../../domain/entity/product.dart';
import '../../domain/entity/roduct_model.dart';
import '../../domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiService apiService;

  ProductRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final response = await apiService.getProducts();
      if (response.statusCode == 200) {
        final products = (response.data as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
        return Right(products);
      } else {
        return Left(ServerFailure("Failed to load products"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
