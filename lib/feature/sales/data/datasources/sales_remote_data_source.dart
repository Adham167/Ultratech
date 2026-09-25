import 'package:flutter/foundation.dart';
import '../../../../core/networks/api_constants.dart';
import '../../../../core/networks/api_service.dart';
import '../../../technician/data/models/order_model.dart';
import '../../../technician/data/models/product_model.dart';
import '../models/agent_model.dart';
import '../models/area_model.dart';
import '../models/check_phone_response_model.dart';
import '../models/create_order_request_dto.dart';
import '../models/customer_check_result_model.dart';
import '../models/customer_profile_model.dart';
import '../models/maintenance_assigned_model.dart';
import '../models/maintenance_decision_request_model.dart';
import '../models/register_customer_request_model.dart';
import '../models/sales_response_model.dart';

abstract class SalesRemoteDataSource {
  Future<SalesResponseModel<CustomerCheckResultModel>> checkPhone(String phoneNumber);
  Future<SalesResponseModel<CheckPhoneResponseModel>> checkPhoneDetails(String phoneNumber);
  Future<SalesResponseModel<CustomerProfileModel>> getCustomerProfile(int customerId);
  Future<SalesResponseModel<OrderModel>> getOrderDetails(int orderId);
  Future<SalesResponseModel<String>> createOrder(CreateOrderRequestDto request);
  Future<SalesResponseModel<List<ProductModel>>> getProducts();
  Future<SalesResponseModel<List<AreaModel>>> getAreas();
  Future<SalesResponseModel<String>> registerCustomer(RegisterCustomerRequestModel request);
  Future<SalesResponseModel<AgentModel>> getAgentProfile();
  Future<SalesResponseModel<List<MaintenanceAssignedModel>>> getAssignedMaintenance({int? decision});
  Future<SalesResponseModel<String>> submitMaintenanceDecision(int maintenanceId, MaintenanceDecisionRequestModel request);
}

class SalesRemoteDataSourceImpl implements SalesRemoteDataSource {
  final ApiService apiService;

  SalesRemoteDataSourceImpl(this.apiService);

  void _logRequest(String method, String endpoint, [dynamic body]) {
    debugPrint("--- API REQUEST ---");
    debugPrint("Method: $method");
    debugPrint("Endpoint: ${ApiConstants.baseUrl}$endpoint");
    if (body != null) debugPrint("Body: $body");
    debugPrint("-------------------");
  }

  void _logResponse(String endpoint, dynamic response) {
    debugPrint("--- API RESPONSE ---");
    debugPrint("Endpoint: $endpoint");
    debugPrint("Response: $response");
    debugPrint("--------------------");
  }

  @override
  Future<SalesResponseModel<CustomerCheckResultModel>> checkPhone(String phoneNumber) async {
    final endpoint = "${ApiConstants.checkPhone}$phoneNumber";
    _logRequest("GET", endpoint);
    try {
      final response = await apiService.get(endpoint: endpoint);
      _logResponse(endpoint, response);
      return SalesResponseModel.fromJson(
        response,
        (data) => CustomerCheckResultModel.fromJson(data),
      );
    } catch (e) {
      debugPrint("Error in checkPhone: $e");
      rethrow;
    }
  }

  @override
  Future<SalesResponseModel<CheckPhoneResponseModel>> checkPhoneDetails(String phoneNumber) async {
    final endpoint = "${ApiConstants.checkPhone}$phoneNumber";
    _logRequest("GET", endpoint);
    try {
      final response = await apiService.get(endpoint: endpoint);
      _logResponse(endpoint, response);
      return SalesResponseModel.fromJson(
        response,
        (data) => CheckPhoneResponseModel.fromJson(data),
      );
    } catch (e) {
      debugPrint("Error in checkPhoneDetails: $e");
      rethrow;
    }
  }

  @override
  Future<SalesResponseModel<CustomerProfileModel>> getCustomerProfile(int customerId) async {
    final endpoint = "Customers/$customerId";
    _logRequest("GET", endpoint);
    try {
      final response = await apiService.get(endpoint: endpoint);
      _logResponse(endpoint, response);
      return SalesResponseModel.fromJson(
        response,
        (data) => CustomerProfileModel.fromJson(data),
      );
    } catch (e) {
      debugPrint("Error in getCustomerProfile: $e");
      rethrow;
    }
  }

  @override
  Future<SalesResponseModel<OrderModel>> getOrderDetails(int orderId) async {
    final endpoint = "Orders/$orderId";
    _logRequest("GET", endpoint);
    try {
      final response = await apiService.get(endpoint: endpoint);
      _logResponse(endpoint, response);

      dynamic orderJson;
      final data = response is Map<String, dynamic> ? response['data'] : null;
      if (data is Map<String, dynamic>) {
        orderJson = data;
      } else if (response is Map<String, dynamic>) {
        orderJson = response;
      }

      if (orderJson is Map<String, dynamic>) {
        return SalesResponseModel<OrderModel>(
          succeeded: response is Map<String, dynamic> ? (response['succeeded'] ?? true) : true,
          message: response is Map<String, dynamic> ? (response['message']?.toString() ?? '') : '',
          data: OrderModel.fromJson(orderJson),
          errors: response is Map<String, dynamic> && response['errors'] is List
              ? List<String>.from(response['errors'])
              : [],
        );
      }

      return SalesResponseModel<OrderModel>(
        succeeded: false,
        message: 'فشل في جلب تفاصيل الأوردر',
        data: null,
        errors: ['Invalid order details format'],
      );
    } catch (e) {
      debugPrint("Error in getOrderDetails: $e");
      rethrow;
    }
  }

  @override
  Future<SalesResponseModel<String>> createOrder(CreateOrderRequestDto request) async {
    const endpoint = "Orders";
    _logRequest("POST", endpoint, request.toJson());
    try {
      final response = await apiService.post(
        endpoint: endpoint,
        body: request.toJson(),
      );
      _logResponse(endpoint, response);
      return SalesResponseModel.fromJson(
        response,
        (data) => data?.toString() ?? response['message']?.toString() ?? "تم إنشاء الأوردر بنجاح",
      );
    } catch (e) {
      debugPrint("Error in createOrder: $e");
      rethrow;
    }
  }

  @override
  Future<SalesResponseModel<List<ProductModel>>> getProducts() async {
    _logRequest("GET", ApiConstants.products);
    try {
      final response = await apiService.get(endpoint: ApiConstants.products);
      _logResponse(ApiConstants.products, response);
      return SalesResponseModel.fromJson(
        response,
        (data) {
          if (data is List) {
            return data.whereType<Map<String, dynamic>>().map((e) => ProductModel.fromJson(e)).toList();
          }
          if (data is Map<String, dynamic> && data['items'] is List) {
            return (data['items'] as List).whereType<Map<String, dynamic>>().map((e) => ProductModel.fromJson(e)).toList();
          }
          return [];
        },
      );
    } catch (e) {
      debugPrint("Error in getProducts: $e");
      rethrow;
    }
  }

  @override
  Future<SalesResponseModel<List<AreaModel>>> getAreas() async {
    _logRequest("GET", ApiConstants.areas);
    try {
      final response = await apiService.get(endpoint: ApiConstants.areas);
      _logResponse(ApiConstants.areas, response);
      return SalesResponseModel.fromJson(
        response,
        (data) {
          if (data is List) {
            return data.map((e) => AreaModel.fromJson(e)).toList();
          }
          return [];
        },
      );
    } catch (e) {
      debugPrint("Error in getAreas: $e");
      rethrow;
    }
  }

  @override
  Future<SalesResponseModel<String>> registerCustomer(RegisterCustomerRequestModel request) async {
    _logRequest("POST", ApiConstants.customers, request.toJson());
    try {
      final response = await apiService.post(
        endpoint: ApiConstants.customers,
        body: request.toJson(),
      );
      _logResponse(ApiConstants.customers, response);
      return SalesResponseModel.fromJson(
        response,
        (data) => data?.toString() ?? "",
      );
    } catch (e) {
      debugPrint("Error in registerCustomer: $e");
      rethrow;
    }
  }

  @override
  Future<SalesResponseModel<AgentModel>> getAgentProfile() async {
    _logRequest("GET", ApiConstants.authMe);
    try {
      final response = await apiService.get(endpoint: ApiConstants.authMe);
      _logResponse(ApiConstants.authMe, response);
      return SalesResponseModel.fromJson(
        response,
        (data) => AgentModel.fromJson(data),
      );
    } catch (e) {
      debugPrint("Error in getAgentProfile: $e");
      rethrow;
    }
  }

  @override
  Future<SalesResponseModel<List<MaintenanceAssignedModel>>> getAssignedMaintenance({int? decision}) async {
    final queryParameters = decision != null ? {'decision': decision} : null;
    _logRequest("GET", ApiConstants.myAssignedMaintenance, queryParameters);
    try {
      final response = await apiService.get(
        endpoint: ApiConstants.myAssignedMaintenance,
        queryParameters: queryParameters,
      );
      _logResponse(ApiConstants.myAssignedMaintenance, response);
      return SalesResponseModel.fromJson(
        response,
        (data) {
          if (data is List) {
            return data.map((e) => MaintenanceAssignedModel.fromJson(e)).toList();
          }
          return [];
        },
      );
    } catch (e) {
      debugPrint("Error in getAssignedMaintenance: $e");
      rethrow;
    }
  }

  @override
  Future<SalesResponseModel<String>> submitMaintenanceDecision(int maintenanceId, MaintenanceDecisionRequestModel request) async {
    final endpoint = "Maintenance/$maintenanceId/decision";
    _logRequest("PUT", endpoint, request.toJson());
    try {
      final response = await apiService.put(
        endpoint: endpoint,
        body: request.toJson(),
      );
      _logResponse(endpoint, response);
      return SalesResponseModel.fromJson(
        response,
        (data) => data?.toString() ?? "",
      );
    } catch (e) {
      debugPrint("Error in submitMaintenanceDecision: $e");
      rethrow;
    }
  }
}
