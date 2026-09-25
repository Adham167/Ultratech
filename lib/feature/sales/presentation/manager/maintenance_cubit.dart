import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_assigned_maintenance_usecase.dart';
import '../../domain/usecases/submit_maintenance_decision_params.dart';
import '../../domain/usecases/submit_maintenance_decision_usecase.dart';
import 'maintenance_state.dart';

class MaintenanceCubit extends Cubit<MaintenanceState> {
  final GetAssignedMaintenanceUseCase getAssignedMaintenanceUseCase;
  final SubmitMaintenanceDecisionUseCase submitMaintenanceDecisionUseCase;

  MaintenanceCubit({
    required this.getAssignedMaintenanceUseCase,
    required this.submitMaintenanceDecisionUseCase,
  }) : super(MaintenanceInitial());

  Future<void> getAssignedMaintenance({int? decision, bool showLoading = true}) async {
    if (showLoading) {
      emit(MaintenanceLoading());
    }
    
    final result = await getAssignedMaintenanceUseCase(decision: decision);

    result.fold(
      (failure) => emit(MaintenanceFailure(failure.errMessage)),
      (list) {
        if (list.isEmpty) {
          emit(MaintenanceEmpty());
        } else {
          emit(MaintenanceSuccess(list));
        }
      },
    );
  }

  Future<void> submitDecision(SubmitMaintenanceDecisionParams params) async {
    emit(MaintenanceDecisionLoading());
    final result = await submitMaintenanceDecisionUseCase(params);

    result.fold(
      (failure) => emit(MaintenanceDecisionFailure(failure.errMessage)),
      (message) {
        emit(MaintenanceDecisionSuccess(message));
        // Silent refresh to keep the Success state visible in the UI listeners
        getAssignedMaintenance(showLoading: false);
      },
    );
  }
}
