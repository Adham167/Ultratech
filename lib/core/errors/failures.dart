import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;
  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioException(dynamic dioException) {
    // هيهندل كل أنواع DioExceptions (TimeOut, BadResponse, NoInternet, 401, 500)
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure("انتهت مهلة الاتصال بالسيرفر");
      case DioExceptionType.sendTimeout:
        return ServerFailure("انتهت مهلة إرسال البيانات");
      case DioExceptionType.receiveTimeout:
        return ServerFailure("انتهت مهلة استقبال البيانات");
      case DioExceptionType.badResponse:
        return ServerFailure._fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure("تم إلغاء الطلب");
      case DioExceptionType.connectionError:
        return ServerFailure("لا يوجد اتصال بإنترنت، تأكد من الشبكة");
      case DioExceptionType.unknown:
        if (dioException.message!.contains('SocketException')) {
          return ServerFailure('لا يوجد اتصال بالإنترنت');
        }
        return ServerFailure("حدث خطأ غير متوقع: ${dioException.message}");
      default:
        return ServerFailure("حدث خطأ غير متوقع، برجاء المحاولة لاحقاً");
    }
  }

  factory ServerFailure._fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      if (response['errors'] != null) {
        if (response['errors'] is List) {
          return ServerFailure((response['errors'] as List).join('\n'));
        } else if (response['errors'] is Map) {
          final List<String> errorMessages = [];
          (response['errors'] as Map).forEach((key, value) {
            if (value is List) {
              errorMessages.add("$key: ${value.join(', ')}");
            } else {
              errorMessages.add("$key: $value");
            }
          });
          return ServerFailure(errorMessages.join('\n'));
        }
      }
      return ServerFailure(
          response['message'] ?? "غير مصرح لك للقيام بهذا الإجراء");
    } else if (statusCode == 404) {
      return ServerFailure("البيانات المطلوبة غير موجودة");
    } else if (statusCode == 500) {
      return ServerFailure("مشكلة في السيرفر الداخلي، حاول لاحقاً");
    } else {
      return ServerFailure("حدث خطأ ما، برجاء المحاولة لاحقاً");
    }
  }
}
