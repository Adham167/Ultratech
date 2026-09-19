import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> get({required String endpoint, Map<String, dynamic>? queryParameters}) async {
    var response = await _dio.get(endpoint, queryParameters: queryParameters);
    return response.data;
  }

  Future<Map<String, dynamic>> post({required String endpoint, required Object body}) async {
    var response = await _dio.post(endpoint, data: body);
    return response.data;
  }

  Future<Map<String, dynamic>> put({required String endpoint, Object? body}) async {
    var response = await _dio.put(endpoint, data: body);
    return response.data;
  }
}