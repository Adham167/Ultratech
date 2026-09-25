import 'package:equatable/equatable.dart';
import '../../domain/entities/maintenance_assigned_entity.dart';

abstract class MaintenanceState extends Equatable {
  const MaintenanceState();

  @override
  List<Object?> get props => [];
}

class MaintenanceInitial extends MaintenanceState {}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceSuccess extends MaintenanceState {
  final List<MaintenanceAssignedEntity> maintenanceList;
  const MaintenanceSuccess(this.maintenanceList);

  @override
  List<Object?> get props => [maintenanceList];
}

class MaintenanceEmpty extends MaintenanceState {}

class MaintenanceFailure extends MaintenanceState {
  final String errMessage;
  const MaintenanceFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class MaintenanceDecisionLoading extends MaintenanceState {}

class MaintenanceDecisionSuccess extends MaintenanceState {
  final String message;
  const MaintenanceDecisionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MaintenanceDecisionFailure extends MaintenanceState {
  final String errMessage;
  const MaintenanceDecisionFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
