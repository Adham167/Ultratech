import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/app_router.dart';
import 'api_constants.dart';

class DioFactory {
  final FlutterSecureStorage _secureStorage =
  const FlutterSecureStorage();

  Dio getDio() {
    final Dio dio = Dio();

    final Map<String, String> headers = {
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

    // تجاوز فحص شهادة SSL الخاصة بسيرفر runasp.net
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      return client;
    };

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          // Requests that explicitly don't require authentication
          // should never receive the Authorization header.
          final requiresAuth =
              options.extra['requiresAuth'] != false;

          // Refresh-token endpoint also doesn't need Authorization.
          if (!requiresAuth ||
              options.path.contains(ApiConstants.refreshToken)) {

            // Debug: print the actual Reset Password request
            if (options.path.contains(ApiConstants.resetPassword)) {
              print('========== RESET PASSWORD REQUEST ==========');
              print('URL: ${options.uri}');
              print('BODY: ${options.data}');
              print('============================================');
            }

            return handler.next(options);
          }

          final token = await _secureStorage.read(
            key: 'token',
          );

          if (token != null && token.isNotEmpty) {
            final authHeader = token.startsWith('Bearer ')
                ? token
                : 'Bearer $token';

            options.headers['Authorization'] = authHeader;
          }

          // Debug: print the actual Reset Password request
          if (options.path.contains(ApiConstants.resetPassword)) {
            print('========== RESET PASSWORD REQUEST ==========');
            print('URL: ${options.uri}');
            print('BODY: ${options.data}');
            print('============================================');
          }

          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final currentToken = await _secureStorage.read(
              key: 'token',
            );

            final requestToken = error
                .requestOptions
                .headers['Authorization']
                ?.toString()
                .replaceFirst('Bearer ', '');

            // Check if token was already refreshed by another
            // concurrent request.
            if (currentToken != null &&
                currentToken.isNotEmpty &&
                currentToken != requestToken) {
              error.requestOptions.headers['Authorization'] =
              'Bearer $currentToken';

              try {
                final response = await _retry(
                  error.requestOptions,
                  dio,
                );

                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }

            final refreshToken = await _secureStorage.read(
              key: 'refreshToken',
            );

            if (refreshToken != null) {
              try {
                final response = await dio.post(
                  ApiConstants.refreshToken,
                  data: {
                    'refreshToken': refreshToken,
                  },
                  options: Options(
                    extra: {
                      'requiresAuth': false,
                    },
                  ),
                );

                if (response.statusCode == 200 &&
                    response.data['succeeded'] == true) {
                  final newData = response.data['data'];

                  final newToken = newData['token'];
                  final newRefreshToken =
                  newData['refreshToken'];

                  await _secureStorage.write(
                    key: 'token',
                    value: newToken,
                  );

                  await _secureStorage.write(
                    key: 'refreshToken',
                    value: newRefreshToken,
                  );

                  if (newData['role'] != null) {
                    await _secureStorage.write(
                      key: 'role',
                      value: newData['role'].toString(),
                    );
                  }

                  if (newData['isApproved'] != null) {
                    await _secureStorage.write(
                      key: 'isApproved',
                      value: newData['isApproved'].toString(),
                    );
                  }

                  error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';

                  final retryResponse = await _retry(
                    error.requestOptions,
                    dio,
                  );

                  return handler.resolve(retryResponse);
                }
              } catch (e) {
                await _secureStorage.deleteAll();

                AppRouter.router.go(
                  AppRouter.kLoginView,
                );

                return handler.reject(error);
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
      RequestOptions requestOptions,
      Dio dio,
      ) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      extra: requestOptions.extra,
    );

    return dio.request(
      requestOptions.path,
      options: options,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }
}