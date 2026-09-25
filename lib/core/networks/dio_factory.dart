import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/app_router.dart';
import 'api_constants.dart';

class DioFactory {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Dio getDio() {
    Dio dio = Dio();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: headers,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      followRedirects: true,
      maxRedirects: 5,
    );

    // 👈 تجاوز فحص شهادة SSL الخاصة بسيرفرات runasp.net
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path.contains(ApiConstants.refreshToken)) {
            return handler.next(options);
          }
          String? token = await _secureStorage.read(key: 'token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            // Check if token was already refreshed by another concurrent request
            String? currentToken = await _secureStorage.read(key: 'token');
            String? requestToken = error.requestOptions.headers['Authorization']
                ?.toString()
                .replaceFirst('Bearer ', '');

            if (currentToken != null &&
                currentToken.isNotEmpty &&
                currentToken != requestToken) {
              // Token has been updated, retry with the new one
              error.requestOptions.headers['Authorization'] =
                  'Bearer $currentToken';
              try {
                final response = await _retry(error.requestOptions, dio);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }

            String? refreshToken = await _secureStorage.read(key: 'refreshToken');
            if (refreshToken != null) {
              try {
                final response = await dio.post(
                  ApiConstants.refreshToken,
                  data: {'refreshToken': refreshToken},
                );

                if (response.statusCode == 200 &&
                    response.data['succeeded'] == true) {
                  final newData = response.data['data'];
                  final newToken = newData['token'];
                  final newRefreshToken = newData['refreshToken'];

                  await _secureStorage.write(key: 'token', value: newToken);
                  await _secureStorage.write(
                      key: 'refreshToken', value: newRefreshToken);
                  if (newData['role'] != null) {
                    await _secureStorage.write(
                        key: 'role', value: newData['role'].toString());
                  }
                  if (newData['isApproved'] != null) {
                    await _secureStorage.write(
                        key: 'isApproved', value: newData['isApproved'].toString());
                  }

                  error.requestOptions.headers['Authorization'] =
                      'Bearer $newToken';
                  final retryResponse = await _retry(error.requestOptions, dio);
                  return handler.resolve(retryResponse);
                }
              } catch (e) {
                await _secureStorage.deleteAll();
                AppRouter.router.go(AppRouter.kLoginView);
                return handler.reject(error); // Ensure handler is not stuck
              }
            }
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, Dio dio) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request(
      requestOptions.path,
      options: options,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }
}