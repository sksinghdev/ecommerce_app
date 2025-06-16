import 'package:common/data/models/odered_product.dart';
import 'package:hive/hive.dart';
 
part 'order_details_model.g.dart';

@HiveType(typeId: 1)
class OrderDetailsModel extends HiveObject {
  @HiveField(0)
  final int userId;

  @HiveField(1)
  final String date; // ISO string or formatted date

  @HiveField(2)
  final List<OderedProduct> products;

  OrderDetailsModel({
    required this.userId,
    required this.date,
    required this.products,
  });
}
