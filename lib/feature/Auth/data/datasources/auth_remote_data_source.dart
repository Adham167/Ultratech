import '../../../../core/networks/api_constants.dart';
import '../../../../core/networks/api_service.dart';
import '../models/request/login_request_model.dart';
import '../models/request/register_request_model.dart';
import '../models/response/auth_response_model.dart';
import '../models/response/user_data_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel<UserDataModel>> login(LoginRequestModel request);
  Future<AuthResponseModel<String>> register(RegisterRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<AuthResponseModel<UserDataModel>> login(LoginRequestModel request) async {
    final response = await apiService.post(
      endpoint: ApiConstants.login,
      body: request.toJson(),
    );
    return AuthResponseModel.fromJson(
      response,
      (data) => UserDataModel.fromJson(data),
    );
  }

  @override
  Future<AuthResponseModel<String>> register(RegisterRequestModel request) async {
    final response = await apiService.post(
      endpoint: ApiConstants.registerEmployee,
      body: request.toJson(),
    );
    return AuthResponseModel.fromJson(
      response,
      (data) => data as String,
    );
  }
}
