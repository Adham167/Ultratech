import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../networks/api_service.dart';
import '../networks/dio_factory.dart';
import '../../feature/Auth/data/datasources/auth_remote_data_source.dart';
import '../../feature/Auth/data/repositories/auth_repository_impl.dart';
import '../../feature/Auth/domain/repositories/auth_repository.dart';
import '../../feature/Auth/domain/usecases/login_usecase.dart';
import '../../feature/Auth/domain/usecases/register_usecase.dart';
import '../../feature/Auth/presentaion/manager/auth_cubit.dart';

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
