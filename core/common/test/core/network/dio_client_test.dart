import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
 
void main() {
  group('DioClient', () {
    test('returns Dio instance with correct base options', () {
      final dioClient = DioClient();
      final dio = dioClient.dio;

      expect(dio.options.baseUrl, 'https://fakestoreapi.com/');
      expect(dio.options.contentType, 'application/json');
      expect(dio.options.responseType, ResponseType.json);

      // Test validateStatus logic
      expect(dio.options.validateStatus(200), isTrue);
      expect(dio.options.validateStatus(400), isTrue);
      expect(dio.options.validateStatus(404), isFalse);
    });
  });
}
