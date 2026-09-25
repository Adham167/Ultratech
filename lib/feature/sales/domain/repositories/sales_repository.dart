import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../technician/data/models/order_model.dart';
import '../../../technician/data/models/product_model.dart';
import '../../data/models/check_phone_response_model.dart';
import '../../data/models/create_order_request_dto.dart';
import '../../data/models/customer_profile_model.dart';
import '../entities/agent_entity.dart';
import '../entities/area_entity.dart';
import '../entities/customer_check_result_entity.dart';
import '../entities/maintenance_assigned_entity.dart';
import '../entities/register_customer_params.dart';
import '../usecases/submit_maintenance_decision_params.dart';

abstract class SalesRepository {
  Future<Either<Failure, CustomerCheckResultEntity>> checkPhone(String phoneNumber);
  Future<Either<Failure, CheckPhoneResponseModel>> checkPhoneDetails(String phoneNumber);
  Future<Either<Failure, CustomerProfileModel>> getCustomerProfile(int customerId);
  Future<Either<Failure, OrderModel>> getOrderDetails(int orderId);
  Future<Either<Failure, String>> createOrder(CreateOrderRequestDto request);
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, List<AreaEntity>>> getAreas();
  Future<Either<Failure, String>> registerCustomer(RegisterCustomerParams params);
  Future<Either<Failure, AgentEntity>> getAgentProfile();
  Future<Either<Failure, List<MaintenanceAssignedEntity>>> getAssignedMaintenance({int? decision});
  Future<Either<Failure, String>> submitMaintenanceDecision(SubmitMaintenanceDecisionParams params);
}
