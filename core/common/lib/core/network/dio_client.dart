
import 'package:dio/dio.dart';

class DioClient {
  Dio get dio => Dio(BaseOptions(
        baseUrl: 'https://fakestoreapi.com/',
        contentType: 'application/json',
        responseType: ResponseType.json,
        validateStatus: (status) => status == 200 || status == 400,
      ));
}