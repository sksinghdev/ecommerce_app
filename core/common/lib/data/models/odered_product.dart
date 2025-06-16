

import 'package:hive/hive.dart';

part 'odered_product.g.dart';

@HiveType(typeId: 0)
class OderedProduct extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String image;

  OderedProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
  });
}
