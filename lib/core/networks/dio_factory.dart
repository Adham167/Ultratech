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
          String? token = await _secureStorage.read(key: 'token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            String? refreshToken = await _secureStorage.read(key: 'refreshToken');
            if (refreshToken != null) {
              try {
                // محاولة تجديد التوكن
                final response = await dio.post(
                  ApiConstants.refreshToken,
                  data: {'refreshToken': refreshToken},
                );

                if (response.statusCode == 200 && response.data['succeeded'] == true) {
                  final newData = response.data['data'];
                  final newToken = newData['token'];
                  final newRefreshToken = newData['refreshToken'];

                  // حفظ البيانات الجديدة
                  await _secureStorage.write(key: 'token', value: newToken);
                  await _secureStorage.write(key: 'refreshToken', value: newRefreshToken);
                  if (newData['role'] != null) {
                    await _secureStorage.write(key: 'role', value: newData['role'].toString());
                  }
                  if (newData['isApproved'] != null) {
                    await _secureStorage.write(key: 'isApproved', value: newData['isApproved'].toString());
                  }

                  // تحديث الهيدر وإعادة الطلب الأصلي
                  error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                  final opts = Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  );
                  final retryResponse = await dio.request(
                    error.requestOptions.path,
                    options: opts,
                    data: error.requestOptions.data,
                    queryParameters: error.requestOptions.queryParameters,
                  );
                  return handler.resolve(retryResponse);
                }
              } catch (e) {
                // فشل تجديد التوكن (مثلاً ريفريش توكن منتهي)
                await _secureStorage.deleteAll();
                
                // توجيه المستخدم لصفحة تسجيل الدخول
                // نستخدم الـ navigatorKey الموجود في AppRouter للوصول للـ context خارج الـ widgets
                AppRouter.router.go(AppRouter.kLoginView);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}