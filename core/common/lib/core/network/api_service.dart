import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<Response> getProducts() async {
    return await dio.get('products');
  }

  Future<Response> createUser(Map<String, dynamic> userData) async {
    return await dio.post('users', data: userData);
  }

  Future<Response> orderPlacedAfterPayment(
      Map<String, dynamic> userData) async {
    return await dio.post('carts', data: userData);
  }

  Future<Response> getUserById(int id) async {
    return await dio.get('users/$id');
  }
}
