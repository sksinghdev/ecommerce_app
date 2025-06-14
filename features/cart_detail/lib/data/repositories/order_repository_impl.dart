 import 'package:common/common.dart';
import 'package:product_listing/domain/entity/product.dart';
import 'package:product_listing/domain/entity/roduct_model.dart';

import '../../domain/repository/order_repository.dart';

 
class OrderRepositoryImpl implements OrderRepository {
  final ApiService apiService;

  const OrderRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<Product>>> placedOrders({
    required int userId,
    required List<Product> products,
  }) async {
    final payload = {
      "userId": userId,
      "date": DateTime.now().toIso8601String(),
      "products": products.map((p) => {
        "productId": p.id,
        "title": p.title,
        "price": p.price,
        "description": p.description,
        "category": p.category,
        "image": p.image,
        "quantity": 1,
      }).toList(),
    };

    try {
   final response  =  await  apiService.orderPlacedAfterPayment(payload);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final productList = (response.data['products'] as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
        return Right(productList);
      } else {
        return Left(ServerFailure("Failed to place order: ${response.statusCode}"));
      }
    } catch (e) {
      throw Exception('Failed to create cart: $e');
    }
  }
}
