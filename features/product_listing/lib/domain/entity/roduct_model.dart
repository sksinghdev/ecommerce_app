 
import 'package:product_listing/domain/entity/product.dart';

class ProductModel extends Product {
const  ProductModel({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
  }) : super(
          id: id,
          title: title,
          price: price,
          description: description,
          category: category,
          image: image,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
    );
  }
}
