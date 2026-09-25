import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../feature/Auth/presentaion/manager/login_cubit/login_cubit.dart';
import '../../feature/Auth/presentaion/manager/register_cubit/register_cubit.dart';
import '../../feature/technician/domain/usecases/get_invoice_by_id_usecase.dart';
import '../../feature/technician/domain/usecases/get_my_earnings_usecase.dart';
import '../../feature/technician/presentation/manager/earnings_cubit/technician_earnings_cubit.dart';
import '../../feature/technician/presentation/manager/invoice_details_cubit/technician_invoice_details_cubit.dart';
import '../networks/api_service.dart';
import '../networks/dio_factory.dart';
import '../../feature/Auth/data/datasources/auth_remote_data_source.dart';
import '../../feature/Auth/data/repositories/auth_repository_impl.dart';
import '../../feature/Auth/domain/repositories/auth_repository.dart';
import '../../feature/Auth/domain/usecases/login_usecase.dart';
import '../../feature/Auth/domain/usecases/register_usecase.dart';
import '../../feature/Auth/domain/usecases/get_user_profile_usecase.dart';
import '../../feature/Auth/presentaion/manager/auth_cubit.dart';
import '../../feature/sales/data/datasources/sales_remote_data_source.dart';
import '../../feature/sales/data/repositories/sales_repository_impl.dart';
import '../../feature/sales/domain/repositories/sales_repository.dart';
import '../../feature/sales/domain/usecases/check_phone_usecase.dart';
import '../../feature/sales/domain/usecases/get_areas_usecase.dart';
import '../../feature/sales/domain/usecases/get_agent_profile_usecase.dart';
import '../../feature/sales/domain/usecases/get_assigned_maintenance_usecase.dart';
import '../../feature/sales/domain/usecases/register_customer_usecase.dart';
import '../../feature/sales/domain/usecases/submit_maintenance_decision_usecase.dart';
import '../../feature/sales/presentation/manager/customer_registration_cubit.dart';
import '../../feature/sales/presentation/manager/customer_profile_cubit.dart';
import '../../feature/sales/presentation/manager/create_order_cubit.dart';
import '../../feature/sales/presentation/manager/sales_order_details_cubit.dart';
import '../../feature/sales/presentation/manager/maintenance_cubit.dart';
import '../../feature/sales/presentation/manager/sales_dashboard_cubit.dart';

import '../../feature/technician/data/datasources/technician_remote_data_source.dart';
import '../../feature/technician/data/repositories/technician_repository_impl.dart';
import '../../feature/technician/domain/repositories/technician_repository.dart';
import '../../feature/technician/domain/usecases/accept_order_usecase.dart';
import '../../feature/technician/domain/usecases/complete_order_usecase.dart';
import '../../feature/technician/domain/usecases/get_my_invoices_usecase.dart';
import '../../feature/technician/domain/usecases/get_my_orders_usecase.dart';
import '../../feature/technician/domain/usecases/get_products_usecase.dart';
import '../../feature/technician/domain/usecases/start_order_usecase.dart';
import '../../feature/technician/presentation/manager/orders_cubit/technician_orders_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerSingleton<Dio>(DioFactory().getDio());
  }
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerSingleton<ApiService>(ApiService(getIt<Dio>()));
  }
  if (!getIt.isRegistered<FlutterSecureStorage>()) {
    getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  }

  // Auth Feature
  initAuthDependencies();
  
  // Sales Feature
  initSalesDependencies();

  // Technician Feature
  initTechnicianDependencies();
}

void initTechnicianDependencies() {
  // DataSources
  if (!getIt.isRegistered<TechnicianRemoteDataSource>()) {
    getIt.registerLazySingleton<TechnicianRemoteDataSource>(
      () => TechnicianRemoteDataSourceImpl(getIt<ApiService>()),
    );
  }

  // Repositories
  if (!getIt.isRegistered<TechnicianRepository>()) {
    getIt.registerLazySingleton<TechnicianRepository>(
      () => TechnicianRepositoryImpl(getIt<TechnicianRemoteDataSource>()),
    );
  }

  // UseCases
  if (!getIt.isRegistered<GetMyOrdersUseCase>()) {
    getIt.registerLazySingleton<GetMyOrdersUseCase>(
      () => GetMyOrdersUseCase(getIt<TechnicianRepository>()),
    );
  }
  if (!getIt.isRegistered<AcceptOrderUseCase>()) {
    getIt.registerLazySingleton<AcceptOrderUseCase>(
      () => AcceptOrderUseCase(getIt<TechnicianRepository>()),
    );
  }
  if (!getIt.isRegistered<StartOrderUseCase>()) {
    getIt.registerLazySingleton<StartOrderUseCase>(
      () => StartOrderUseCase(getIt<TechnicianRepository>()),
    );
  }
  if (!getIt.isRegistered<CompleteOrderUseCase>()) {
    getIt.registerLazySingleton<CompleteOrderUseCase>(
      () => CompleteOrderUseCase(getIt<TechnicianRepository>()),
    );
  }
  if (!getIt.isRegistered<GetProductsUseCase>()) {
    getIt.registerLazySingleton<GetProductsUseCase>(
      () => GetProductsUseCase(getIt<TechnicianRepository>()),
    );
  }
  if (!getIt.isRegistered<GetMyInvoicesUseCase>()) {
    getIt.registerLazySingleton<GetMyInvoicesUseCase>(
      () => GetMyInvoicesUseCase(getIt<TechnicianRepository>()),
    );
  }
  if (!getIt.isRegistered<GetMyEarningsUseCase>()) {
    getIt.registerLazySingleton<GetMyEarningsUseCase>(
          () => GetMyEarningsUseCase(
        getIt<TechnicianRepository>(),
      ),
    );
  }
  if (!getIt.isRegistered<GetInvoiceByIdUseCase>()) {
    getIt.registerLazySingleton<GetInvoiceByIdUseCase>(
          () => GetInvoiceByIdUseCase(
        getIt<TechnicianRepository>(),
      ),
    );
  }

  // Cubit
  if (!getIt.isRegistered<TechnicianOrdersCubit>()) {
    getIt.registerFactory<TechnicianOrdersCubit>(
      () => TechnicianOrdersCubit(
        getMyOrdersUseCase: getIt<GetMyOrdersUseCase>(),
        acceptOrderUseCase: getIt<AcceptOrderUseCase>(),
        startOrderUseCase: getIt<StartOrderUseCase>(),
        completeOrderUseCase: getIt<CompleteOrderUseCase>(),
        getProductsUseCase: getIt<GetProductsUseCase>(),
        getMyInvoicesUseCase: getIt<GetMyInvoicesUseCase>(),
      ),
    );
  }
  if (!getIt.isRegistered<GetUserProfileUseCase>()) {
    getIt.registerLazySingleton<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(getIt<TechnicianRepository>()),
    );
  }

  if (!getIt.isRegistered<TechnicianEarningsCubit>()) {
    getIt.registerFactory<TechnicianEarningsCubit>(
      () => TechnicianEarningsCubit(
        getMyEarningsUseCase: getIt<GetMyEarningsUseCase>(),
        getUserProfileUseCase: getIt<GetUserProfileUseCase>(),
      ),
    );
  }
  if (!getIt.isRegistered<TechnicianInvoiceDetailsCubit>()) {
    getIt.registerFactory<TechnicianInvoiceDetailsCubit>(
          () => TechnicianInvoiceDetailsCubit(
        getIt<GetInvoiceByIdUseCase>(),
      ),
    );
  }

}

void initAuthDependencies() {
  // DataSources
  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt<ApiService>()),
    );
  }

  // Repositories
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
    );
  }

  // UseCases
  if (!getIt.isRegistered<LoginUseCase>()) {
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    );
  }
  if (!getIt.isRegistered<RegisterUseCase>()) {
    getIt.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(getIt<AuthRepository>()),
    );
  }

  // Cubits
  if (!getIt.isRegistered<AuthCubit>()) {
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(
        loginUseCase: getIt<LoginUseCase>(),
        registerUseCase: getIt<RegisterUseCase>(),
        secureStorage: getIt<FlutterSecureStorage>(),
      ),
    );
  }
}

void initSalesDependencies() {
  // DataSources
  if (!getIt.isRegistered<SalesRemoteDataSource>()) {
    getIt.registerLazySingleton<SalesRemoteDataSource>(
      () => SalesRemoteDataSourceImpl(getIt<ApiService>()),
    );
  }

  // Repositories
  if (!getIt.isRegistered<SalesRepository>()) {
    getIt.registerLazySingleton<SalesRepository>(
      () => SalesRepositoryImpl(getIt<SalesRemoteDataSource>()),
    );
  }

  // UseCases
  if (!getIt.isRegistered<CheckPhoneUseCase>()) {
    getIt.registerLazySingleton<CheckPhoneUseCase>(
      () => CheckPhoneUseCase(getIt<SalesRepository>()),
    );
  }
  if (!getIt.isRegistered<GetAreasUseCase>()) {
    getIt.registerLazySingleton<GetAreasUseCase>(
      () => GetAreasUseCase(getIt<SalesRepository>()),
    );
  }
  if (!getIt.isRegistered<RegisterCustomerUseCase>()) {
    getIt.registerLazySingleton<RegisterCustomerUseCase>(
      () => RegisterCustomerUseCase(getIt<SalesRepository>()),
    );
  }
  if (!getIt.isRegistered<GetAgentProfileUseCase>()) {
    getIt.registerLazySingleton<GetAgentProfileUseCase>(
      () => GetAgentProfileUseCase(getIt<SalesRepository>()),
    );
  }
  if (!getIt.isRegistered<GetAssignedMaintenanceUseCase>()) {
    getIt.registerLazySingleton<GetAssignedMaintenanceUseCase>(
      () => GetAssignedMaintenanceUseCase(getIt<SalesRepository>()),
    );
  }
  if (!getIt.isRegistered<SubmitMaintenanceDecisionUseCase>()) {
    getIt.registerLazySingleton<SubmitMaintenanceDecisionUseCase>(
      () => SubmitMaintenanceDecisionUseCase(getIt<SalesRepository>()),
    );
  }

  // Cubits
  if (!getIt.isRegistered<CustomerRegistrationCubit>()) {
    getIt.registerFactory<CustomerRegistrationCubit>(
      () => CustomerRegistrationCubit(
        checkPhoneUseCase: getIt<CheckPhoneUseCase>(),
        getAreasUseCase: getIt<GetAreasUseCase>(),
        registerCustomerUseCase: getIt<RegisterCustomerUseCase>(),
      ),
    );
  }
  if (!getIt.isRegistered<MaintenanceCubit>()) {
    getIt.registerFactory<MaintenanceCubit>(
      () => MaintenanceCubit(
        getAssignedMaintenanceUseCase: getIt<GetAssignedMaintenanceUseCase>(),
        submitMaintenanceDecisionUseCase: getIt<SubmitMaintenanceDecisionUseCase>(),
      ),
    );
  }
  if (!getIt.isRegistered<CustomerProfileCubit>()) {
    getIt.registerFactory<CustomerProfileCubit>(
      () => CustomerProfileCubit(getIt<SalesRepository>()),
    );
  }
  if (!getIt.isRegistered<CreateOrderCubit>()) {
    getIt.registerFactory<CreateOrderCubit>(
      () => CreateOrderCubit(getIt<SalesRepository>()),
    );
  }
  if (!getIt.isRegistered<SalesOrderDetailsCubit>()) {
    getIt.registerFactory<SalesOrderDetailsCubit>(
      () => SalesOrderDetailsCubit(getIt<SalesRepository>()),
    );
  }
  if (!getIt.isRegistered<SalesDashboardCubit>()) {
    getIt.registerFactory<SalesDashboardCubit>(
      () => SalesDashboardCubit(getIt<GetAgentProfileUseCase>()),
    );
  }
  getIt.registerFactory<LoginCubit>(
        () => LoginCubit(
      loginUseCase: getIt<LoginUseCase>(),
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );

  getIt.registerFactory<RegisterCubit>(
        () => RegisterCubit(
      registerUseCase: getIt<RegisterUseCase>(),
    ),
  );

}
