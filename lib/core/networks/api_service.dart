import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<dynamic> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    final response = await _dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: Options(
        extra: {
          'requiresAuth': requiresAuth,
        },
      ),
    );

    return response.data;
  }

  Future<dynamic> post({
    required String endpoint,
    required Object body,
    bool requiresAuth = true,
  }) async {
    final response = await _dio.post(
      endpoint,
      data: body,
      options: Options(
        extra: {
          'requiresAuth': requiresAuth,
        },
      ),
    );

    return response.data;
  }

  Future<dynamic> put({
    required String endpoint,
    Object? body,
    bool requiresAuth = true,
  }) async {
    final response = await _dio.put(
      endpoint,
      data: body,
      options: Options(
        extra: {
          'requiresAuth': requiresAuth,
        },
      ),
    );

    return response.data;
  }
}