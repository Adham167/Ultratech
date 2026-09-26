import 'package:flutter/foundation.dart';
import '../../../../core/networks/api_constants.dart';
import '../../../../core/networks/api_service.dart';
import '../../../Auth/data/models/response/user_profile_model.dart';
import '../models/complete_order_request_model.dart';
import '../models/invoice_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/technician_response_model.dart';
import '../models/earnings_model.dart';

abstract class TechnicianRemoteDataSource {
  Future<TechnicianResponseModel<List<OrderModel>>> getMyOrders({int? status});

  Future<TechnicianResponseModel<OrderModel>> getOrderDetails(int orderId);

  Future<TechnicianResponseModel<String>> acceptOrder(int orderId);

  Future<TechnicianResponseModel<String>> startOrder(int orderId);

  Future<TechnicianResponseModel<String>> completeOrder(
    int orderId,
    CompleteOrderRequestModel request,
  );

  Future<TechnicianResponseModel<List<ProductModel>>> getProducts({
    bool onlyInStock = true,
  });

  Future<TechnicianResponseModel<List<InvoiceModel>>> getMyInvoices({
    int? status,
  });

  Future<TechnicianResponseModel<EarningsModel>> getMyEarnings();

  Future<TechnicianResponseModel<InvoiceModel>> getInvoiceById(int invoiceId);

  Future<TechnicianResponseModel<UserProfileModel>> getUserProfile();

  Future<TechnicianResponseModel<String>> updateOrderLocation(
    int orderId,
    double latitude,
    double longitude,
  );
}

class TechnicianRemoteDataSourceImpl implements TechnicianRemoteDataSource {
  final ApiService apiService;

  TechnicianRemoteDataSourceImpl(this.apiService);

  void _logRequest(String method, String endpoint, [dynamic body]) {
    debugPrint("--- TECHNICIAN API REQUEST ---");
    debugPrint("Method: $method");
    debugPrint("Endpoint: ${ApiConstants.baseUrl}$endpoint");
    if (body != null) debugPrint("Body: $body");
    debugPrint("------------------------------");
  }

  void _logResponse(String endpoint, dynamic response) {
    debugPrint("--- TECHNICIAN API RESPONSE ---");
    debugPrint("Endpoint: $endpoint");
    debugPrint("Response: $response");
    debugPrint("-------------------------------");
  }

  List<OrderModel> _parseOrdersList(dynamic json) {
    if (json == null) return [];

    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map((e) => OrderModel.fromJson(e))
          .toList();
    }

    if (json is Map<String, dynamic>) {
      final data = json['data'];

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((e) => OrderModel.fromJson(e))
            .toList();
      }

      if (data is Map<String, dynamic>) {
        if (data['items'] is List) {
          return (data['items'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => OrderModel.fromJson(e))
              .toList();
        } else if (data['orders'] is List) {
          return (data['orders'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => OrderModel.fromJson(e))
              .toList();
        }
      }

      if (json['items'] is List) {
        return (json['items'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => OrderModel.fromJson(e))
            .toList();
      } else if (json['orders'] is List) {
        return (json['orders'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => OrderModel.fromJson(e))
            .toList();
      }
    }

    return [];
  }

  List<ProductModel> _parseProductsList(dynamic json) {
    if (json == null) return [];

    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    if (json is Map<String, dynamic>) {
      final data = json['data'];

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((e) => ProductModel.fromJson(e))
            .toList();
      }

      if (data is Map<String, dynamic>) {
        if (data['items'] is List) {
          return (data['items'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => ProductModel.fromJson(e))
              .toList();
        } else if (data['products'] is List) {
          return (data['products'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => ProductModel.fromJson(e))
              .toList();
        }
      }

      if (json['items'] is List) {
        return (json['items'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => ProductModel.fromJson(e))
            .toList();
      } else if (json['products'] is List) {
        return (json['products'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => ProductModel.fromJson(e))
            .toList();
      }
    }

    return [];
  }

  List<InvoiceModel> _parseInvoicesList(dynamic json) {
    if (json == null) return [];

    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map((e) => InvoiceModel.fromJson(e))
          .toList();
    }

    if (json is Map<String, dynamic>) {
      final data = json['data'];

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((e) => InvoiceModel.fromJson(e))
            .toList();
      }

      if (data is Map<String, dynamic>) {
        if (data['items'] is List) {
          return (data['items'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => InvoiceModel.fromJson(e))
              .toList();
        } else if (data['invoices'] is List) {
          return (data['invoices'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => InvoiceModel.fromJson(e))
              .toList();
        }
      }

      if (json['items'] is List) {
        return (json['items'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => InvoiceModel.fromJson(e))
            .toList();
      } else if (json['invoices'] is List) {
        return (json['invoices'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => InvoiceModel.fromJson(e))
            .toList();
      }
    }

    return [];
  }

  @override
  Future<TechnicianResponseModel<List<OrderModel>>> getMyOrders({
    int? status,
  }) async {
    final queryParams = status != null ? {'status': status} : null;
    _logRequest("GET", ApiConstants.myOrders, queryParams);
    try {
      final response = await apiService.get(
        endpoint: ApiConstants.myOrders,
        queryParameters: queryParams,
      );
      _logResponse(ApiConstants.myOrders, response);
      debugPrint("DEBUG getMyOrders RAW JSON RESPONSE: $response");

      final orders = _parseOrdersList(response);

      if (response is Map<String, dynamic>) {
        final succeeded = response['succeeded'] ?? true;
        final message = response['message']?.toString() ?? '';
        final errors = response['errors'] != null && response['errors'] is List
            ? List<String>.from(response['errors'])
            : <String>[];

        return TechnicianResponseModel<List<OrderModel>>(
          succeeded: succeeded,
          message: message,
          data: orders,
          errors: errors,
        );
      }

      return TechnicianResponseModel<List<OrderModel>>(
        succeeded: true,
        message: 'تم جلب الأوردرات بنجاح',
        data: orders,
        errors: [],
      );
    } catch (e) {
      debugPrint("Error in getMyOrders: $e");
      rethrow;
    }
  }

  @override
  Future<TechnicianResponseModel<String>> acceptOrder(int orderId) async {
    final endpoint = ApiConstants.acceptOrder(orderId);
    _logRequest("PUT", endpoint);
    try {
      final response = await apiService.put(endpoint: endpoint);
      _logResponse(endpoint, response);

      if (response is Map<String, dynamic>) {
        return TechnicianResponseModel.fromJson(
          response,
          (data) =>
              data?.toString() ??
              response['message']?.toString() ??
              "تم قبول الأوردر بنجاح",
        );
      }

      return TechnicianResponseModel<String>(
        succeeded: true,
        message: "تم قبول الأوردر بنجاح",
        data: "تم قبول الأوردر بنجاح",
        errors: [],
      );
    } catch (e) {
      debugPrint("Error in acceptOrder: $e");
      rethrow;
    }
  }

  @override
  Future<TechnicianResponseModel<String>> startOrder(int orderId) async {
    final endpoint = ApiConstants.startOrder(orderId);
    _logRequest("PUT", endpoint);
    try {
      final response = await apiService.put(endpoint: endpoint);
      _logResponse(endpoint, response);

      if (response is Map<String, dynamic>) {
        return TechnicianResponseModel.fromJson(
          response,
          (data) =>
              data?.toString() ??
              response['message']?.toString() ??
              "تم التأكيد وبدء العمل بنجاح",
        );
      }

      return TechnicianResponseModel<String>(
        succeeded: true,
        message: "تم التأكيد وبدء العمل بنجاح",
        data: "تم التأكيد وبدء العمل بنجاح",
        errors: [],
      );
    } catch (e) {
      debugPrint("Error in startOrder: $e");
      rethrow;
    }
  }

  @override
  Future<TechnicianResponseModel<String>> completeOrder(
    int orderId,
    CompleteOrderRequestModel request,
  ) async {
    final endpoint = ApiConstants.completeOrder(orderId);
    _logRequest("POST", endpoint, request.toJson());
    try {
      final response = await apiService.post(
        endpoint: endpoint,
        body: request.toJson(),
      );
      _logResponse(endpoint, response);

      if (response is Map<String, dynamic>) {
        return TechnicianResponseModel.fromJson(
          response,
          (data) =>
              data?.toString() ??
              response['message']?.toString() ??
              "تم إنهاء العمل وإصدار الفاتورة بنجاح",
        );
      }

      return TechnicianResponseModel<String>(
        succeeded: true,
        message: "تم إنهاء العمل وإصدار الفاتورة بنجاح",
        data: "تم إنهاء العمل وإصدار الفاتورة بنجاح",
        errors: [],
      );
    } catch (e) {
      debugPrint("Error in completeOrder: $e");
      rethrow;
    }
  }

  @override
  Future<TechnicianResponseModel<List<ProductModel>>> getProducts({
    bool onlyInStock = true,
  }) async {
    final queryParams = {'onlyInStock': onlyInStock};
    _logRequest("GET", ApiConstants.products, queryParams);
    try {
      final response = await apiService.get(
        endpoint: ApiConstants.products,
        queryParameters: queryParams,
      );
      _logResponse(ApiConstants.products, response);

      final products = _parseProductsList(response);

      if (response is Map<String, dynamic>) {
        final succeeded = response['succeeded'] ?? true;
        final message = response['message']?.toString() ?? '';
        final errors = response['errors'] != null && response['errors'] is List
            ? List<String>.from(response['errors'])
            : <String>[];

        return TechnicianResponseModel<List<ProductModel>>(
          succeeded: succeeded,
          message: message,
          data: products,
          errors: errors,
        );
      }

      return TechnicianResponseModel<List<ProductModel>>(
        succeeded: true,
        message: 'تم جلب المنتجات بنجاح',
        data: products,
        errors: [],
      );
    } catch (e) {
      debugPrint("Error in getProducts: $e");
      rethrow;
    }
  }

  @override
  Future<TechnicianResponseModel<List<InvoiceModel>>> getMyInvoices({
    int? status,
  }) async {
    final queryParams = status != null ? {'status': status} : null;
    _logRequest("GET", ApiConstants.myInvoices, queryParams);
    try {
      final response = await apiService.get(
        endpoint: ApiConstants.myInvoices,
        queryParameters: queryParams,
      );
      _logResponse(ApiConstants.myInvoices, response);

      final invoices = _parseInvoicesList(response);

      if (response is Map<String, dynamic>) {
        final succeeded = response['succeeded'] ?? true;
        final message = response['message']?.toString() ?? '';
        final errors = response['errors'] != null && response['errors'] is List
            ? List<String>.from(response['errors'])
            : <String>[];

        return TechnicianResponseModel<List<InvoiceModel>>(
          succeeded: succeeded,
          message: message,
          data: invoices,
          errors: errors,
        );
      }

      return TechnicianResponseModel<List<InvoiceModel>>(
        succeeded: true,
        message: 'تم جلب الفواتير بنجاح',
        data: invoices,
        errors: [],
      );
    } catch (e) {
      debugPrint("Error in getMyInvoices: $e");
      rethrow;
    }
  }

  @override
  Future<TechnicianResponseModel<EarningsModel>> getMyEarnings() async {
    _logRequest('GET', ApiConstants.myEarnings);

    try {
      final response = await apiService.get(endpoint: ApiConstants.myEarnings);

      _logResponse(ApiConstants.myEarnings, response);

      if (response is Map<String, dynamic>) {
        final succeeded = response['succeeded'] ?? true;

        final message = response['message']?.toString() ?? '';

        final errors = response['errors'] is List
            ? List<String>.from(response['errors'])
            : <String>[];

        dynamic dataJson;

        final data = response['data'];

        if (data is Map<String, dynamic>) {
          dataJson = data;
        } else {
          dataJson = response;
        }

        if (dataJson is Map<String, dynamic>) {
          return TechnicianResponseModel<EarningsModel>(
            succeeded: succeeded,
            message: message,
            data: EarningsModel.fromJson(dataJson),
            errors: errors,
          );
        }

        return TechnicianResponseModel<EarningsModel>(
          succeeded: false,
          message: 'لم يتم العثور على بيانات الأرباح',
          data: null,
          errors: ['Invalid earnings data'],
        );
      }

      return TechnicianResponseModel<EarningsModel>(
        succeeded: false,
        message: 'استجابة غير صحيحة من الخادم',
        data: null,
        errors: ['Invalid response format'],
      );
    } catch (e) {
      debugPrint('Error in getMyEarnings: $e');
      rethrow;
    }
  }

  @override
  Future<TechnicianResponseModel<InvoiceModel>> getInvoiceById(
    int invoiceId,
  ) async {
    final endpoint = ApiConstants.invoiceDetails(invoiceId);

    _logRequest('GET', endpoint);

    try {
      final response = await apiService.get(endpoint: endpoint);

      _logResponse(endpoint, response);

      if (response is Map<String, dynamic>) {
        final succeeded = response['succeeded'] ?? true;

        final message = response['message']?.toString() ?? '';

        final errors = response['errors'] is List
            ? List<String>.from(response['errors'])
            : <String>[];

        dynamic invoiceJson;

        final data = response['data'];

        if (data is List && data.isNotEmpty) {
          invoiceJson = data.first;
        } else if (data is Map<String, dynamic>) {
          invoiceJson = data;
        } else {
          invoiceJson = response;
        }

        if (invoiceJson is Map<String, dynamic>) {
          return TechnicianResponseModel<InvoiceModel>(
            succeeded: succeeded,
            message: message,
            data: InvoiceModel.fromJson(invoiceJson),
            errors: errors,
          );
        }

        return TechnicianResponseModel<InvoiceModel>(
          succeeded: false,
          message: 'لم يتم العثور على بيانات الفاتورة',
          data: null,
          errors: ['Invalid invoice data'],
        );
      }

      return TechnicianResponseModel<InvoiceModel>(
        succeeded: false,
        message: 'استجابة غير صحيحة من الخادم',
        data: null,
        errors: ['Invalid response format'],
      );
    } catch (e) {
      debugPrint('Error in getInvoiceById: $e');
      rethrow;
    }
  }

  @override
  Future<TechnicianResponseModel<UserProfileModel>> getUserProfile() async {
    _logRequest('GET', ApiConstants.authMe);
    try {
      final response = await apiService.get(endpoint: ApiConstants.authMe);
      _logResponse(ApiConstants.authMe, response);

      if (response is Map<String, dynamic>) {
        final succeeded = response['succeeded'] ?? true;
        final message = response['message']?.toString() ?? '';
        final errors = response['errors'] is List
            ? List<String>.from(response['errors'])
            : <String>[];

        final data = response['data'];
        if (data is Map<String, dynamic>) {
          return TechnicianResponseModel<UserProfileModel>(
            succeeded: succeeded,
            message: message,
            data: UserProfileModel.fromJson(data),
            errors: errors,
          );
        }
      }

      return TechnicianResponseModel<UserProfileModel>(
        succeeded: false,
        message: 'فشل في جلب بيانات المستخدم',
        data: null,
        errors: ['Invalid response'],
      );
    } catch (e) {
      debugPrint('Error in getUserProfile: $e');
      rethrow;
    }
  }

  @override
  Future<TechnicianResponseModel<String>> updateOrderLocation(
    int orderId,
    double latitude,
    double longitude,
  ) async {
    final endpoint = "Orders/$orderId/customer-location";
    final body = {"latitude": latitude, "longitude": longitude};
    _logRequest("PUT", endpoint, body);
    try {
      final response = await apiService.put(endpoint: endpoint, body: body);
      _logResponse(endpoint, response);

      if (response is Map<String, dynamic>) {
        return TechnicianResponseModel.fromJson(
          response,
          (data) =>
              data?.toString() ??
              response['message']?.toString() ??
              "تم تحديث موقع العميل بنجاح",
        );
      }

      return TechnicianResponseModel<String>(
        succeeded: true,
        message: "تم تحديث موقع العميل بنجاح",
        data: "تم تحديث موقع العميل بنجاح",
        errors: [],
      );
    } catch (e) {
      debugPrint("Error in updateOrderLocation: $e");
      rethrow;
    }
  }

  @override
  Future<TechnicianResponseModel<OrderModel>> getOrderDetails(
      int orderId,
      ) async {
    final endpoint = 'Orders/$orderId';

    _logRequest('GET', endpoint);

    try {
      final response = await apiService.get(
        endpoint: endpoint,
      );

      _logResponse(endpoint, response);

      if (response is! Map<String, dynamic>) {
        return TechnicianResponseModel<OrderModel>(
          succeeded: false,
          message: 'استجابة غير صحيحة من الخادم',
          data: null,
          errors: ['Invalid response format'],
        );
      }

      final succeeded = response['succeeded'] ?? false;
      final message = response['message']?.toString() ?? '';

      final errors = response['errors'] is List
          ? List<String>.from(response['errors'])
          : <String>[];

      final data = response['data'];

      if (data is! Map<String, dynamic>) {
        return TechnicianResponseModel<OrderModel>(
          succeeded: false,
          message: 'لم يتم العثور على تفاصيل الأوردر',
          data: null,
          errors: errors.isNotEmpty
              ? errors
              : ['Invalid order details data'],
        );
      }

      final order = OrderModel.fromJson(data);

      debugPrint(
        'DEBUG getOrderDetails: '
            'orderId=$orderId, '
            'items=${order.items.length}, '
            'itemsCount=${order.itemsCount}',
      );

      return TechnicianResponseModel<OrderModel>(
        succeeded: succeeded,
        message: message,
        data: order,
        errors: errors,
      );
    } catch (e) {
      debugPrint('Error in getOrderDetails: $e');
      rethrow;
    }
  }
}
