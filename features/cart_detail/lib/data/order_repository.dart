

import 'package:common/common.dart';
import 'package:product_listing/domain/entity/product.dart';
class OrderRepository {
  final Dio dio;

  OrderRepository(this.dio);

  Future<void> placeOrder(List<Product> products, int userId) async {
    final response = await dio.post(
      'https://fakestoreapi.com/carts',
      data: {
        "userId": userId,
        "date": DateTime.now().toIso8601String(),
        "products": products.map((p) => {
          "productId": p.id,
          "quantity": 1 ,
        }).toList(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to place order");
    }
  }
}
