import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_agent_profile_usecase.dart';
import 'sales_dashboard_state.dart';

class SalesDashboardCubit extends Cubit<SalesDashboardState> {
  final GetAgentProfileUseCase getAgentProfileUseCase;

  SalesDashboardCubit(this.getAgentProfileUseCase) : super(SalesDashboardInitial());

  Future<void> getProfile() async {
    emit(SalesDashboardLoading());
    final result = await getAgentProfileUseCase();

    result.fold(
      (failure) => emit(SalesDashboardFailure(failure.errMessage)),
      (agent) => emit(SalesDashboardSuccess(agent)),
    );
  }
}
